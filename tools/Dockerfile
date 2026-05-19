# container for testing with various shells
FROM ubuntu:26.04
RUN apt -y update && apt -y install \
	bash \
	curl \
	dash \
	git \
	ksh \
	posh \
	zsh
RUN curl -fsSL https://git.io/shellspec >install.sh &&\
	chmod +x install.sh &&\
	./install.sh -y
ENV PATH=/root/.local/bin:$PATH
ENV TERM=xterm-256color
