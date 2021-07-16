# # Stage that builds the application, a prerequisite for the running stage
# FROM maven:3-openjdk-16-slim as build
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
# RUN apt-get update -qq && apt-get install -qq --no-install-recommends nodejs
#
# # Stop running as root at this point
# RUN useradd -m myuser
# WORKDIR /usr/src/app/
# RUN chown myuser:myuser /usr/src/app/
# USER myuser
#
# # Copy pom.xml and prefetch dependencies so a repeated build can continue from the next step with existing dependencies
# COPY --chown=myuser pom.xml ./
# # RUN mvn dependency:go-offline -Pproduction
#
# # Copy all needed project files to a folder
# COPY --chown=myuser:myuser src src
# COPY --chown=myuser:myuser frontend frontend
# COPY --chown=myuser:myuser package.json ./
#
# # Using * after the files that are autogenerated so that so build won't fail if they are not yet created
# COPY --chown=myuser:myuser package-lock.json* pnpm-lock.yaml* webpack.config.js* ./
#
#
# # Build the production package, assuming that we validated the version before so no need for running tests again
# RUN mvn clean package -DskipTests -Pproduction
#
# # Running stage: the part that is used for running the application
# FROM openjdk:16-jdk-slim
# COPY --from=build /usr/src/app/target/*.war /usr/app/ai-chat.war
# RUN useradd -m myuser
# USER myuser
# EXPOSE 8080
# CMD java -jar target/ai-chat.war
FROM openjdk:16-jdk-slim
ARG JAR_FILE=target/*.war
COPY ${JAR_FILE} app.war
ENTRYPOINT ["java", "-Xmx128m", "-jar", "app.war", "--server.port=8080"]
EXPOSE 8080