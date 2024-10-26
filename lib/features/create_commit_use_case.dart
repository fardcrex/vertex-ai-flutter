import 'package:firebase_vertexai/firebase_vertexai.dart';

class CreateCommitUseCase {
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
    systemInstruction: Content.system(
        '''Te voy a proporcionar el resultado de un `git diff`. Quiero que generes un mensaje de commit basado en ese diff, utilizando el formato de Conventional Commits. Asegúrate de seguir estas reglas:

1. Elige un tipo de commit entre los siguientes, según el tipo de cambio que observes en el código: ["feat", "fix", "docs", "style", "refactor", "perf", "test", "chore", "build", "ci", "revert", "merge", "hotfix", "config", "deps", "sec", "localization"].

2. Si el cambio es un bugfix, usa "fix". Si es una nueva funcionalidad, usa "feat". Si son cambios menores como actualización de dependencias o cambios de configuración, usa "chore". Si el cambio es una optimización de rendimiento, usa "perf". Si es refactorización de código, usa "refactor". Si es un cambio de estilo, usa "style". Si es documentación, usa "docs". Si es un test, usa "test". Usa "ci" si los cambios afectan la integración continua y "build" si afectan el sistema de construcción. Si no puedes determinar el tipo, usa "chore".

3. Usa el siguiente formato para el mensaje:
   - `<tipo>(<alcance opcional>): <resumen del cambio>`
   - Añade una descripción más detallada en el cuerpo si es necesario (máximo 72 caracteres por línea).
   - Si el commit cierra un issue o ticket, añade un footer que diga: `Closes #<número de issue>`.

4. Mantén el título en 50 caracteres como máximo.

Aquí está el `git diff`:

<PEGA EL RESULTADO DE `GIT DIFF` AQUÍ>

Devuélveme el mensaje de commit generado en el formato solicitado.'''),
  );

  Future<String> execute({
    required String promptCodeChanges,
    required String promptDescription,
  }) async {
    final response = await model.generateContent([
      Content.text(
          'La descripciòn del proyecto es: $promptDescription\n\nEl código de cambios [Git Diff] es: $promptCodeChanges')
    ]);

    return response.text.toString();
  }
}
