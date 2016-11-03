module dwig.source;

class Source
{
	private{
		string _code, _name, _path;
	}

	this(string code, string name, string path = "")
	{
		this._code = code;
		this._name = name;
		this._path = path;
	}

	@property string code(){
		return _code;
	}

	@property string name(){
		return _name;
	}
	@property string path(){
		return _path;
	}
}

