# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY HfWebApi/*.csproj ./HfWebApi/
RUN dotnet restore

# copy everything else and build app
COPY HfWebApi/. ./HfWebApi/
WORKDIR /source/HfWebApi
RUN dotnet publish -c release -o /app 
#--no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "HfWebApi.dll"]
