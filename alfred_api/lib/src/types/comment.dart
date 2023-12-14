import 'package:code_builder/code_builder.dart';

class Comment extends CodeExpression {
  final List<String> comments;
  final bool isDoc;

  static List<String> _split(String comment) => comment.split('\n');

  static String _join(List<String> comments, bool isDoc) =>
      comments.map((l) => '${isDoc ? '///' : '//'} $l').join('\n');

  Comment.line(final String comment)
      : comments = _split(comment),
        isDoc = false,
        super(Code(_join(_split(comment), false)));
  Comment.doc(final String comment)
      : comments = _split(comment),
        isDoc = true,
        super(Code(_join(_split(comment), true)));
  Comment.multiline(this.comments)
      : isDoc = true,
        super(Code(_join(comments, true)));
}
