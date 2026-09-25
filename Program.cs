var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Mapeia "/" para servir um arquivo HTML
app.MapGet("/", () =>
{
    // Caminho absoluto ou relativo do arquivo HTML
    var filePath = Path.Combine(app.Environment.ContentRootPath, "wwwroot", "index.html");

    // Verifica se o arquivo existe
    if (!File.Exists(filePath))
    {
        return Results.NotFound("Arquivo HTML não encontrado.");
    }

    // Retorna o arquivo com o tipo MIME correto
    return Results.File(filePath, "text/html");
});

// Habilita servir arquivos estáticos (CSS, JS, imagens, etc.)
app.UseStaticFiles();

app.Run();
