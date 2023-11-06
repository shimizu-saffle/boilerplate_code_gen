import 'package:analyzer/dart/element/element.dart';
import 'package:boilerplate_code_annotation/boilerplate_code_annotation.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class BoilerplateCodeGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'CopyWith annotation can only be applied to classes. '
        'The target `${element.name}` is not a class. ',
        todo: 'Remove the CopyWith annotation from `${element.name}` '
            'or change `${element.name}` to a class. ',
        element: element,
      );
    }

    final classElement = element;
    final fields = classElement.fields;

    final buffer = StringBuffer();
    buffer.writeln(
      'extension ${classElement.name}CopyWithExtension on ${classElement.name} '
      '{',
    );
    buffer.writeln('${classElement.name} copyWith({');

    for (final field in fields) {
      buffer.writeln(
        '${field.type.getDisplayString(withNullability: false)}? '
        '${field.name},',
      );
    }

    buffer.writeln('}) {');
    buffer.writeln('return ${classElement.name}(');

    for (final field in fields) {
      buffer.writeln('${field.name}: ${field.name} ?? this.${field.name},');
    }

    buffer.writeln(');');
    buffer.writeln('}');
    buffer.writeln('}');

    return buffer.toString();
  }
}
