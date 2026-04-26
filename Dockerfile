FROM tomcat:10.1-jdk17

# Copy source files
COPY src/ /app/src/
COPY build/WEB-INF/lib/ /app/lib/

# Compile Java files
RUN find /app/src -name "*.java" > /app/sources.txt && \
    javac -cp "/app/lib/*" -d /app/classes @/app/sources.txt

# Setup webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY build/ /usr/local/tomcat/webapps/ROOT/
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    cp -r /app/classes/* /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]