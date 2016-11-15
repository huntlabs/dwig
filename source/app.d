import std.stdio;
import std.datetime;
import dwig.source;
import dwig.lexer;
import dwig.parser;
import std.experimental.logger;

void main()
{

	auto source = new Source(import("index.html"), "index.html");

	LexerInterface lexer = new Lexer();
	auto stream = lexer.tokenize(source);
	/*while(!stream.empty)
	{
		auto xx = stream.next;
		trace("stream:", xx.type, xx.value, xx.lineno);
	}*/
	Parser p = new Parser();
	p.parse(stream);

	//writeln("source:", source.code);
}
