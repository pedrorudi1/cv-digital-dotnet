# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS builder
WORKDIR /src

# Copy project file and restore dependencies (leverages layer caching)
COPY cv-digital.csproj .
RUN dotnet restore

# Copy source code and build
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Copy only published artifacts from builder
COPY --from=builder /app/publish .

EXPOSE 8000
ENV ASPNETCORE_URLS=http://+:8000
ENV ASPNETCORE_ENVIRONMENT=Production

# Run as non-root (app user already exists in aspnet image)
RUN chown -R app:app /app
USER app

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD dotnet /app/cv-digital.dll --version || exit 1

ENTRYPOINT ["dotnet", "cv-digital.dll"]
