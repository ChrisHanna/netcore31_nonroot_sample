# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
RUN useradd -u 8877 chris
WORKDIR /app
RUN chown -R chris:chris /app
RUN chmod 755 /app
USER chris
EXPOSE 8089
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
