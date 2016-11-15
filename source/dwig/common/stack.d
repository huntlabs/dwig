module dwig.common.stack;

struct Stack(T)
{
	private{
		T[] data;
		size_t current = -1;
	}

	void push(T t)
	{
		if( current == data.length -1)
		{
			data ~= t;
			import std.stdio;
			current ++;
			writeln(data, current);
		}
		else
		{
			data[++current] = t;
			import std.stdio;
			writeln(data, current);
		}

	}

	T pop()
	{
		if(empty())
		{
			throw new Exception("Cannot pop ,stack is empty");
		}
		auto _t =  data[current];
		current--;
		return _t;
	}

	bool empty()
	{
		return current == -1;
	}
}

unittest{

	Stack!int statck;
	statck.push(1);
	statck.push(2);
	statck.push(3);
	statck.push(4);
	import std.stdio;
	//writeln(statck.pop());
	assert(statck.pop() == 4);
	statck.push(5);
	statck.push(6);
	assert(statck.pop() == 6);
}
