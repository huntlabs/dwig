module dwig.lexer;

import std.regex;
import std.string;
import std.stdio;
import std.experimental.logger;

import dwig.tokenstream;
import dwig.source;

import dwig.common.tools;
import dwig.token;
import dwig.common.stack;

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

//do not change
enum auto TagOptions = [
	"tag_comment":["{#", "#}"],
	"tag_block":["{%", "%}"],
	"tag_variable":["{{", "}}"],
	"whitespace_trim":["-"],
	"interpolation":["#{", "}"],
]; 


enum auto LexerRegexes = [
//	"lex_var" : `\s*`.escaper ~ TagOptions["whitespace_trim"][0].escaper ~ TagOptions["tag_variable"][1].escaper ~ `\s*|\s*`.escaper ~TagOptions["tag_variable"][1].escaper ~`/`,
	//"lex_comment" : `/(?:` ~TagOptions["whitespace_trim"][0] ~ TagOptions["tag_comment"][1] ~`\s*|`~TagOptions["tag_comment"][1] ~`)\n?/s`,
	"lex_comment" : r"(?:\-#\}\s*|#\})\n?",
	//"lex_tokens_start" : "(" ~ TagOptions["tag_variable"][0].escaper~ "|" ~ TagOptions["tag_block"][0].escaper ~"|"~ TagOptions["tag_comment"][0].escaper~")("~ TagOptions["whitespace_trim"][0].escaper~")?",
	"lex_tokens_start" : r"(\{\{|\{%|\{#)(\-)?"
];

alias StringCaptures =  Captures!(string, size_t);

///Lexes a template string.
class Lexer : LexerInterface
{

	enum int STATE_DATA = 0;
	enum int STATE_BLOCK = 1;
	enum int STATE_VAR = 2;
	enum int STATE_STRING = 3;
	enum int  STATE_INTERPOLATION = 4;
	
	const REGEX_NAME = `/[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*/A`;
	const REGEX_NUMBER =`/[0-9]+(?:\.[0-9]+)?/A`;
	const REGEX_STRING =`/"([^#"\\\\]*(?:\\\\.[^#"\\\\]*)*)"|\'([^\'\\\\]*(?:\\\\.[^\'\\\\]*)*)\'/As`;
	const REGEX_DQ_STRING_DELIM =`/"/A`;
	const REGEX_DQ_STRING_PART =`/[^#"\\\\]*(?:(?:\\\\.|#(?!\{))[^#"\\\\]*)*/As`;
	const PUNCTUATION = `()[]{}?:.,|`;


	private{
		Source source;
		string filename, code;
		size_t cursor, lineno,positon, state, currentVarBlockLize;
		size_t end;
		StringCaptures capture;
		Token[] tokens;
		Stack!int states;
	}

	public TokenStream tokenize(Source _source,string name = null) {
		source = _source;
		code = source.code.replace(r"\r\n|\r", "\n");
		filename = source.name;
		cursor = 0;
		lineno = 1;
		end = code.length;
		state = STATE_DATA;
		//writeln(LexerRegexes);
		auto r = regex(LexerRegexes["lex_tokens_start"], "s");
		auto position = matchAll(code, r);
		auto ms = matchAll(code, r);
	/*	if(ms.empty)
		{
			return;
		}*/
		foreach(c;ms)
		{
			capture = c;
			trace("pre----",c.pre);
			trace("hit----",c.hit);
			trace("post----",c.post);

			switch(state)
			{
				case STATE_DATA:
					lexData();
					break;
				case STATE_BLOCK:
					lexBlock();
					break;
					
				case STATE_VAR:
					lexVar();
					break;
					
				case STATE_STRING:
					lexString();
					break;
					
				case STATE_INTERPOLATION:
					lexInterpolation();
					break;
				default:
					throw new Exception("not support");
			}

		}
		return new TokenStream(tokens,source);
	}


	private void lexData()
	{
		positon = capture.pre.length;
		trace("positon:", positon);
		if(cursor <  positon)
		{
			pushToken(TokenType.TEXT_TYPE, code[cursor .. positon]);
		}
		trace("position: ", positon, " cursor:" , cursor, "code:", code[cursor .. positon]);
		cursor = positon + capture.hit.length;
		switch(capture.hit)
		{

			case TagOptions["tag_comment"][0]://{#
				lexComment();
			break;
			case TagOptions["tag_block"][0]://{%
				lexComment();
				break;
			case TagOptions["tag_variable"][0]://{{
				pushToken(TokenType.VAR_START_TYPE);
				this.states.push(STATE_VAR);
				currentVarBlockLize = lineno;
				break;
			default:
				break;
		}
	}

	private void lexBlock()
	{}
	private void lexVar()
	{}
	private void lexString()
	{}
	private void lexInterpolation()
	{}

	private void lexComment(){
		auto r = regex(LexerRegexes["lex_comment"], "s");
		trace("comment..", capture.post);
		trace("lex_comment", LexerRegexes["lex_comment"]);
		auto f = matchFirst(capture.post, r);
		if(f.empty)
		{
			throw new Exception("Unclosed comment ");
		}
		trace("f.pre:", f.pre);
		trace("f.hit:", f.hit);
		trace("f.post:", f.post);
		cursor = f.pre.length + f.hit.length;
		positon = cursor;

	}

	private void pushToken(TokenType type, string value = "")
	{
		if(type == TokenType.TEXT_TYPE && value.length == 0)
			return;
		tokens ~= new Token(type,value, lineno);
	}
}