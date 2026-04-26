FROM tomcat:10.1-jdk17
RUN apt-get update && apt-get install -y default-mysql-client
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY build/ /usr/local/tomcat/webapps/ROOT/
COPY sql/schema.sql /docker-entrypoint-initdb.d/schema.sql
EXPOSE 8080
CMD ["catalina.sh", "run"]