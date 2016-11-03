module dwig.lexer;

import std.regex;
import std.array;

import dwig.tokenstream;
import dwig.source;


///Interface implemented by lexer classes
interface LexerInterface
{
	/**
     * Tokenizes a source code.
     *
     * @param string|Twig_Source code The source code
     * @param string             name A unique identifier for the source code
     *
     * @return TokenStream A token stream instance
     *
     * @throws Error_Syntax When the code is syntactically wrong
     */
	public TokenStream tokenize(Source code, string name = null);
}

enum auto TagOptions = [
	"tag_comment":["{#", "#}"],
	"tag_block":["{%", "%}"],
	"tag_variable":["{{", "}}"],
	"whitespace_trim":["-"],
	"interpolation":["#{", "}"],
]; 


enum auto LexerRegexes = [
	"lex_var" : `/\s*` ~ TagOptions["whitespace_trim"][0] ~ TagOptions["tag_variable"][1] ~ `\s*|\s*` ~TagOptions["tag_variable"][1] ~`/A`,
	"lex_comment" : `/(?:` ~TagOptions["whitespace_trim"][0] ~ TagOptions["tag_comment"][1] ~`\s*|`~TagOptions["tag_comment"][1] ~`)\n?/s`,
];


///Lexes a template string.
class Lexer : LexerInterface
{

	const int STATE_DATA = 0;
	const int STATE_BLOCK = 1;
	const int STATE_VAR = 2;
	const int STATE_STRING = 3;
	const int  STATE_INTERPOLATION = 4;
	
	const REGEX_NAME = `/[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*/A`;
	const REGEX_NUMBER =`/[0-9]+(?:\.[0-9]+)?/A`;
	const REGEX_STRING =`/"([^#"\\\\]*(?:\\\\.[^#"\\\\]*)*)"|\'([^\'\\\\]*(?:\\\\.[^\'\\\\]*)*)\'/As`;
	const REGEX_DQ_STRING_DELIM =`/"/A`;
	const REGEX_DQ_STRING_PART =`/[^#"\\\\]*(?:(?:\\\\.|#(?!\{))[^#"\\\\]*)*/As`;
	const PUNCTUATION = `()[]{}?:.,|`;


	private{
		Source source;
		string filename, code;
		int cursor, lineno,positon, state;
		size_t end;
	}

	public TokenStream tokenize(Source _source,string name = null) {
		source = _source;
		code = source.code.replace(["\r\n", "\r"], ["\n", "\n"]);
		filename = source.name;
		cursor = 0;
		lineno = 1;
		end = code.length;
		state = STATE_DATA;
	}
}