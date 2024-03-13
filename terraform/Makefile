shell:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf --entrypoint=/bin/sh -it hashicorp/terraform

bootstrap:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform apply -target aws_route53_zone.joshbeard_me

init:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform init -reconfigure -upgrade -backend-config=backend/backend.tfvars

plan:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform plan

apply:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform apply

output:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform output

refresh:
	docker run --env-file=aws.env -v ${PWD}/site:/tf -w /tf -it hashicorp/terraform refresh
