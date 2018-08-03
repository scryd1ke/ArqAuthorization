# PROSMART - Common Dockerfile NET Core multi-stage builder
# Be VERY specific about SDK dotnet cli version for building the app
FROM microsoft/dotnet:2.1.302-sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./

# If there is a custom nuget configuration file uncomment next line, copy over to the new image
# COPY nuget.config 
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image. Again, BE SPECIFIC about running version, DLL must be project name
FROM microsoft/dotnet:2.1.2-aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Arq.Authorization.dll"]