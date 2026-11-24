// Walks the user through copying each part to the clipboard (SQF cannot write files).
// Call with spawn.
params ["_items", ["_i", 0]];
if (_i >= count _items) exitWith {
	["Deformer export: all parts copied.", 0] call BIS_fnc_3DENNotification;
};
uiSleep 0.15;
DTB_queue = _items;
DTB_qIdx = _i;
(_items select _i) params ["_label", "_file", "_text"];
private _first = (_i == 0) || {((_items select (_i - 1)) select 1) != _file};
private _how = ["<t font='RobotoCondensedBold'>append</t> to", "paste into a <t font='RobotoCondensedBold'>new</t> file"] select _first;
private _msg = format [
	"<t font='RobotoCondensedBold'>%1</t> (%2 of %3)<br/>Click COPY, then %4 <t font='EtelkaMonospaceProBold'>%5</t>.<br/>%6 characters.",
	_label, _i + 1, count _items, _how, _file, count _text
];
[
	_msg,
	"Deformer -> Terrain Builder",
	["COPY", {
		copyToClipboard ((DTB_queue select DTB_qIdx) select 2);
		[DTB_queue, DTB_qIdx + 1] spawn DTB_fnc_showParts;
	}],
	["Cancel", {}],
	""
] call BIS_fnc_3DENShowMessage;
