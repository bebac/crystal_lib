require "type"

class Clang::Cursor
  def initialize(@cursor)
  end

  def kind
    LibClang.get_cursor_kind(self)
  end

  def type
    Type.new(LibClang.get_cursor_type(self))
  end

  def display_name
    String.new(LibClang.get_cursor_display_name(self))
  end

  def spelling
    String.new(LibClang.get_cursor_spelling(self))
  end

  def location
    SourceLocation.new(LibClang.get_cursor_location(self))
  end

  def visit_children(&block : Cursor -> Symbol)
    LibClang.visit_children(@cursor, ->(cursor, parent, data) {
      proc = Box(Cursor -> Symbol).unbox(data)

      case result = proc.call(Cursor.new(cursor))
      when :break
        LibClang::VisitResult::Break
      when :continue
        LibClang::VisitResult::Continue
      when :recurse
        LibClang::VisitResult::Recurse
      else
        raise "Invalid result for visitor: #{result}"
      end
    }, Box(Cursor -> Symbol).box(block))
  end

  def declaration?
    LibClang.is_declaration(kind) != 0
  end

  def reference?
    LibClang.is_reference(kind) != 0
  end

  def expression?
    LibClang.is_expression(kind) != 0
  end

  def statement?
    LibClang.is_statement(kind) != 0
  end

  def attribute?
    LibClang.is_attribute(kind) != 0
  end

  def invalid?
    LibClang.is_invalid(kind) != 0
  end

  def translation_unit?
    LibClang.is_translation_unit(kind) != 0
  end

  def preprocessing?
    LibClang.is_preprocessing(kind) != 0
  end

  def unexposed?
    LibClang.is_unexposed(kind) != 0
  end

  def to_unsafe
    @cursor
  end

end