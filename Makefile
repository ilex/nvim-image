build:
	docker build -t nvim_image .
run:
	docker run -it -u 1000:1000 nvim_image nvim
