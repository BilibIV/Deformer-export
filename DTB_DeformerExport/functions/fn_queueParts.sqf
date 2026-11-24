// Splits text lines into clipboard-sized parts.
// Returns [[label, fileName, text], ...]
params ["_lines", "_label", "_file", ["_limit", 1500000]];
private _nl = toString [10];
private _parts = [];
private _buf = [];
private _n = 0;
{
	_buf pushBack _x;
	_n = _n + (count _x) + 1;
	if (_n >= _limit) then {
		_parts pushBack ((_buf joinString _nl) + _nl);
		_buf = [];
		_n = 0;
	};
} forEach _lines;
if (count _buf > 0) then { _parts pushBack ((_buf joinString _nl) + _nl) };

private _cnt = count _parts;
private _items = [];
{
	_items pushBack [format ["%1 - part %2/%3", _label, _forEachIndex + 1, _cnt], _file, _x];
} forEach _parts;
_items
