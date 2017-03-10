.DEFAULT: start
.PHONY: start test

start :
	@docker-compose up

test :
	@docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm app
