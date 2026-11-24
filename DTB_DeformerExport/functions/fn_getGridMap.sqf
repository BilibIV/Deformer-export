// Returns the Deformer edit map: HashMap  [gx,gy] -> [newZ, baseZ]
// Prefers the live GF_gridMap (includes unsaved edits), falls back to the scenario attribute.
private _live = missionNamespace getVariable ["GF_gridMap", objNull];
if (_live isEqualType createHashMap && {count _live > 0}) exitWith { _live };

private _str = "GF_deformMission" get3DENMissionAttribute "GF_deformString";
if (isNil "_str" || {!(_str isEqualType "")} || {count _str < 6}) exitWith { createHashMap };

if ((_str select [0,1]) == "[") exitWith {
	["importoldlong", [_str]] call GF_fnc_deformFunc
};

private _arr = ["uncompressMap", [_str select [1, count _str]]] call GF_fnc_deformFunc;
createHashMapFromArray (_arr apply { [[_x select 0, _x select 1], [_x select 2, _x select 2]] })
