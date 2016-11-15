module dwig.token;

import std.traits;

enum TokenType{
	EOF_TYPE = -1,
	TEXT_TYPE = 0,
	BLOCK_START_TYPE = 1,
	VAR_START_TYPE = 2,
	BLOCK_END_TYPE = 3,
	VAR_END_TYPE = 4,
	NAME_TYPE = 5,
	NUMBER_TYPE = 6,
	STRING_TYPE = 7,
	OPERATOR_TYPE = 8,
	PUNCTUATION_TYPE = 9,
	INTERPOLATION_START_TYPE = 10,
	INTERPOLATION_END_TYPE = 11,
}

class Token
{
	private{
		string _value;
		size_t _lineno;
		TokenType _type;
	}

	this(TokenType type, string value, size_t lineno)
	{
		_type = type;
		_value = value;
		_lineno = lineno;
	}

	@property TokenType type(){return _type;}

	@property size_t lineno(){return _lineno;}
	@property string value(){return _value;}


	private string typeToString(TokenType type, bool _short = false )
	{
		string name = type.stringof;
		return _short ? name : "TokenType:"~ name;
	}


	override string toString() {
		import std.format;
		return format("%s(%s)", typeToString(_type, true), _value);
	}
}

