module dwig.common.tools;
import std.regex;
import std.exception, std.uni, std.meta, std.traits, std.typecons, std.range.primitives;
// Characters that need escaping in string posed as regular expressions
alias Escapables = AliasSeq!('[', ']', '\\', '^', '$', '.', '|', '?', ',', '-',
	';', ':', '#', '&', '%', '/', '<', '>', '`',  '*', '+', '(', ')', '{', '}',  '~');

auto escaper(Range)(Range r)
{
	import std.algorithm.searching : find;
	static immutable escapables = [Escapables];
	static struct Escaper // template to deduce attributes
	{
		Range r;
		bool escaped;
		
		@property ElementType!Range front(){
			if (escaped)
				return '\\';
			else
				return r.front;
		}
		
		@property bool empty(){ return r.empty; }
		
		void popFront(){
			if (escaped) escaped = false;
			else
			{
				r.popFront();
				if (!r.empty && !escapables.find(r.front).empty)
					escaped = true;
			}
		}
		
		@property auto save(){ return Escaper(r.save, escaped); }
	}
	
	bool escaped = !r.empty && !escapables.find(r.front).empty;
	return Escaper(r, escaped);
}

///
unittest
{
	import std.regex;
	import std.algorithm.comparison;
	string s = `This is {unfriendly} to *regex*`;
	import std.stdio;
	writeln(s.escaper);
	assert(s.escaper.equal(`This is \{unfriendly\} to \*regex\*`));
}