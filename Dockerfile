# Build stage
FROM public.ecr.aws/docker/library/httpd:2.4

RUN mkdir -p /usr/local/apache2/htdocs/app2
COPY index.html /usr/local/apache2/htdocs/index.html
COPY index.html /usr/local/apache2/htdocs/app2/index.html
EXPOSE 80