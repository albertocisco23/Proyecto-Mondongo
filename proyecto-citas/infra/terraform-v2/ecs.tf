resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/ecs/${local.name_prefix}/api"
  retention_in_days = 7

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-cluster"

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}

# IAM roles for ECS tasks
data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.name_prefix}-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Allow tasks to read our secret
resource "aws_iam_policy" "secrets_read" {
  name = "${local.name_prefix}-secrets-read"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "secrets_read_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_read.arn
}

resource "aws_ecs_task_definition" "api" {
  family                   = "${local.name_prefix}-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = var.image_uri
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      # IMPORTANTE:
      # - Forzamos DATABASE_URL a apuntar a RDS (nada de localhost)
      # - Insertamos un placeholder __PASSWORD__ y lo sustituimos en runtime
      environment = [
        { name = "ADMIN_TOKEN", value = var.admin_token },

        {
          name  = "DATABASE_URL",
          value = "postgresql+psycopg2://${var.db_username}:__PASSWORD__@${aws_db_instance.postgres.address}:5432/${var.db_name}"
        },

        # Opcional: variables extra por claridad/debug
        { name = "DB_HOST", value = aws_db_instance.postgres.address },
        { name = "DB_NAME", value = var.db_name },
        { name = "DB_USER", value = var.db_username },
        { name = "DB_PORT", value = "5432" }
      ]

      # La password real viene de Secrets Manager
      secrets = [
        {
          name      = "DB_PASSWORD",
          valueFrom = "${aws_secretsmanager_secret.db_secret.arn}:password::"
        }
      ]

      # Sustituimos __PASSWORD__ por $DB_PASSWORD y arrancamos uvicorn
      # Nota: aquí usamos $$ para que Terraform NO intente interpolar variables.
      command = [
        "sh",
        "-lc",
        "export DATABASE_URL=\"$(echo $$DATABASE_URL | sed 's/__PASSWORD__/'\"$$DB_PASSWORD\"'/g')\" && exec uvicorn app.main:app --host 0.0.0.0 --port 8000"
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8000/health').read()\" || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 20
      }
    }
  ])

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_ecs_service" "api" {
  name            = "${local.name_prefix}-api-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.ecs_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "api"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]

  tags = {
    Env     = var.env
    Project = var.project
    Owner   = var.owner
  }
}