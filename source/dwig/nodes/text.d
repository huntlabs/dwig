module dwig.nodes.text;
import dwig.node;

class TextNode : BaseNode
{
	this(string data,size_t lineno)
	{
		super(null, ["data" : data], lineno);
	}
}

