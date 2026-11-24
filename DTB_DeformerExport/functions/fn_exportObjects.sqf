// mode "converted": objects in the "Deformer converts" layer + list of the original terrain objects to delete in TB
// mode "all":       every editor object (E2TB-style)
// Output line format (Terrain Builder text import):  "name";x;y;yaw;pitch;roll;scale;relativeZ;
params [["_mode", "converted"]];

private _xOff     = missionNamespace getVariable ["DTB_xOffset", 200000];
private _yOff     = missionNamespace getVariable ["DTB_yOffset", 0];
private _yawMode  = missionNamespace getVariable ["DTB_yawMode", 0];      // 0 = heading as is, 1 = 360 - heading
private _nameMode = missionNamespace getVariable ["DTB_nameMode", "model"]; // "model" (p3d name) or "class"

private _modelName = {
	private _m = ((getModelInfo _this) select 1);
	private _i = (toLower _m) find ".p3d";
	if (_i >= 0) then { _m = _m select [0, _i] };
	_m
};

private _layer = (all3DENEntities select 6) select { ((_x get3DENAttribute "name") select 0) == "Deformer converts" };

private _objs = [];
if (_mode == "converted") then {
	if (count _layer > 0) then {
		_objs = (get3DENLayerEntities (_layer select 0)) select { _x isEqualType objNull };
	};
} else {
	_objs = (all3DENEntities select 0) select {
		!(_x isKindOf "Logic") && {!(_x isKindOf "CAManBase") && {((typeOf _x) select [0,11]) != "GF_deformer"}}
	};
};

if (count _objs == 0) exitWith {
	["Deformer: no objects to export.", 1] call BIS_fnc_3DENNotification;
};

private _lines = [];
private _ids = [];
{
	private _o = _x;
	private _p = getPosASL _o;
	private _pb = [_o] call BIS_fnc_getPitchBank;
	private _yaw = getDir _o;
	if (_yawMode == 1) then { _yaw = (360 - _yaw) mod 360 };
	private _name = if (_nameMode == "class") then { typeOf _o } else { _o call _modelName };
	private _relZ = (_p select 2) - (getTerrainHeightASL _p);

	_lines pushBack format [
		"""%1"";%2;%3;%4;%5;%6;%7;%8;",
		_name,
		(_xOff + (_p select 0)) toFixed 3,
		(_yOff + (_p select 1)) toFixed 3,
		_yaw toFixed 3,
		(_pb select 0) toFixed 3,
		(_pb select 1) toFixed 3,
		(getObjectScale _o) toFixed 4,
		_relZ toFixed 3
	];

	if (_mode == "converted") then {
		private _nm = (_o get3DENAttribute "name") select 0;
		if (_nm isEqualType "") then {
			private _sp = _nm splitString "x_";
			if (count _sp > 0 && {(_nm select [0,1]) == "x"}) then { _ids pushBack (_sp select 0) };
		};
	};
} forEach _objs;

// Original terrain objects that were hidden by the conversion (so they can be deleted in TB)
private _del = [];
if (count _ids > 0) then {
	private _nums = _ids apply { parseNumber _x };
	_nums sort true;
	private _last = [worldSize / 2, worldSize / 2];
	{
		private _t = _last nearestObject _x;
		if (!isNull _t) then {
			_last = getPos _t;
			private _tp = getPosASL _t;
			_del pushBack format [
				"""%1"";%2;%3;id %4",
				_t call _modelName,
				(_xOff + (_tp select 0)) toFixed 3,
				(_yOff + (_tp select 1)) toFixed 3,
				getObjectID _t
			];
		};
	} forEach _nums;
};

diag_log format ["DTB export: %1 objects, %2 originals to delete", count _lines, count _del];

private _items = [_lines, "Objects", "objects_import.txt"] call DTB_fnc_queueParts;
if (count _del > 0) then {
	_items append ([_del, "Original objects to delete", "objects_delete_list.txt"] call DTB_fnc_queueParts);
};
[_items, 0] spawn DTB_fnc_showParts;
