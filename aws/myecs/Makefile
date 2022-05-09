.EXPORT_ALL_VARIABLES:
include .aws_env

up:
	docker context use myecscontext
	docker compose --project-name aline_financial up

down:
	docker compose down