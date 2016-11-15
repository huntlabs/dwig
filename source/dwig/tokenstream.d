module dwig.tokenstream;

import dwig.token;
import dwig.source;

///Represents a token stream.
class TokenStream
{

	private{
		Token[] tokens;
		size_t current = 0;
		string filename;
		Source source;
	}

	this(Token[] tokens, Source _source)
	{
		this.source = _source;
		this.tokens  = tokens;

		this.filename = _source.name;
	}

	Token next()
	{
		current ++;
		if(current > tokens.length)
		{
			throw new Exception("Unexcepted end of template");
		}
		return tokens[current - 1];
	}

	bool isEOF()
	{
		//return tokens[current].type == TokenType.EOF_TYPE;
		return current == tokens.length;
	}

	bool empty()
	{
		return current == tokens.length;
	}

	Token getCurrent()
	{
		return tokens[current];
	}

	string fileName()
	{
		return source.name;
	}

	string getSource()
	{
		return source.code;
	}
	Source getSource()
	{
		return source;
	}
}

