module dwig.node;

interface NodeInterface{
	void compile();
	size_t line();
	void nodeTag();
}

class BaseNode : NodeInterface
{

	private{
		NodeInterface[] nodes;
		string[string]  attributes;
		size_t lineno;
	}

	this(NodeInterface[] _nodes = null, string[string] _attrs = null, size_t lineno = 0)
	{
		nodes = _nodes;
		attributes = _attrs;
		this.lineno = lineno;
	}

	void compile(){}
	size_t line(){
		return 0;
	}
	void nodeTag(){}
}

