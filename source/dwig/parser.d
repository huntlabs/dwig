module dwig.parser;

import dwig.tokenstream;
import dwig.token;
import dwig.node;
import dwig.nodes.text;
import std.experimental.logger;

interface ParserInterface
{
	void parse(TokenStream stream);
}

class Parser : ParserInterface
{
	private
	{
		TokenStream stream;
	}

	this()
	{
		// Constructor code
	}
	void parse(TokenStream stream)
	{
		this.stream = stream;
		auto xx = subparse();
	}

	NodeInterface subparse()
	{
		auto lineno = stream.getCurrent.lineno;
		trace("lineno:", lineno);
		NodeInterface[] rv;
		while(!stream.empty)
		{
			trace("stream.getCurrent.type:", stream.getCurrent.type);
			switch(stream.getCurrent.type)
			{
				case TokenType.TEXT_TYPE:
					auto token = stream.next;
					trace("token.value:", token.value);
					trace("--------------------------------------");
					rv ~= new TextNode(token.value, token.lineno);
					break;
				case TokenType.VAR_START_TYPE:
					auto token = stream.next;
					//TODO
					break;
				case TokenType.BLOCK_START_TYPE:
					auto token = stream.next;
					///TODO
					break;
				default:
					throw new Exception("Lexer or parser error");
			}
		}
		if(rv.length == 1)
			return rv[0];
		return new BaseNode(rv);
	}
}

