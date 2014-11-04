require "lib_clang_enums"

@[Link("clang")]
@[Link(ldflags: "-L`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/lib")]
@[Link(ldflags: "-rpath `xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/lib")]
lib LibClang
  type Index = Void*
  type TranslationUnit = Void*

  struct Cursor
    kind : Int32
    xdata : Int32
    data : Pointer(Void)[3]
  end

  struct Type
    kind : Int32
    data : Pointer(Void)[2]
  end

  enum VisitResult
    Break,
    Continue,
    Recurse
  end

  type CursorVisitor = (Cursor, Cursor, Void*) -> Int32

  struct UnsavedFile
    filename : UInt8*
    contents : UInt8*
    length : UInt64
  end

  struct SourceLocation
    ptr_data : Pointer(Void)[2]
    int_data : UInt32
  end

  fun create_index = clang_createIndex(excludeDeclarationsFromPCH : Int32, displayDiagnostics : Int32) : Index
  fun parse_translation_unit = clang_parseTranslationUnit(idx : Index,
                                                          source_filename : UInt8*,
                                                          command_line_args : UInt8**,
                                                          num_command_line_args : Int32,
                                                          unsaved_files : UnsavedFile*,
                                                          num_unsaved_files : UInt32,
                                                          options : UInt32) : TranslationUnit
  fun create_translation_unit_from_source_file = clang_createTranslationUnitFromSourceFile(
                                                    Index,
                                                    source_filename : UInt8*,
                                                    num_clang_command_line_args : Int32,
                                                    clang_command_line_args : UInt8**,
                                                    num_unsaved_files : UInt32,
                                                    unsaved_files : UnsavedFile*) : TranslationUnit

  fun get_translation_unit_cursor = clang_getTranslationUnitCursor(TranslationUnit) : Cursor
  fun visit_children = clang_visitChildren(Cursor, CursorVisitor, client_data : Void*) : UInt32
  fun get_num_diagnostics = clang_getNumDiagnostics(TranslationUnit) : UInt32
  fun get_cursor_kind = clang_getCursorKind(Cursor) : Int32
  fun get_cursor_type = clang_getCursorType(Cursor) : Type
  fun get_type_spelling = clang_getTypeSpelling(Type) : UInt8*

  fun is_declaration = clang_isDeclaration(CursorKind) : UInt32
  fun is_reference = clang_isReference(CursorKind) : UInt32
  fun is_expression = clang_isExpression(CursorKind) : UInt32
  fun is_statement = clang_isStatement(CursorKind) : UInt32
  fun is_attribute = clang_isAttribute(CursorKind) : UInt32
  fun is_invalid = clang_isInvalid(CursorKind) : UInt32
  fun is_translation_unit = clang_isTranslationUnit(CursorKind) : UInt32
  fun is_preprocessing = clang_isPreprocessing(CursorKind) : UInt32
  fun is_unexposed = clang_isUnexposed(CursorKind) : UInt32

  fun get_canonical_type = clang_getCanonicalType(Type) : Type
  fun get_cursor_spelling = clang_getCursorSpelling(Cursor) : UInt8*
  fun get_cursor_display_name = clang_getCursorDisplayName(Cursor) : UInt8*
  fun get_cursor_location = clang_getCursorLocation(Cursor) : SourceLocation
  fun location_is_from_main_file = clang_Location_isFromMainFile(SourceLocation) : Int32
  # fun get_expansion_location = clang_getExpansionLocation(SourceLocation location,
  #                                              CXFile *file,
  #                                              unsigned *line,
  #                                              unsigned *column,
  #                                              unsigned *offset);

end