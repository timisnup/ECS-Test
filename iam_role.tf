# generates an iam policy document in json format for the ecs task execution role
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# create an iam role
resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecs-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

# attach ecs task execution policy to the iam role
resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

