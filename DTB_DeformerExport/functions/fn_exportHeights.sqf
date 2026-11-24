// Exports the edited part of the terrain as an ESRI ASCII grid patch.
// Values come from the Deformer edit map where edited, and from the live terrain elsewhere inside the box.
params [["_margin", 1]];
private _map = call DTB_fnc_getGridMap;
if (count _map == 0) exitWith {
	["Deformer: no terrain edits found in this scenario.", 1] call BIS_fnc_3DENNotification;
};

[_map, _margin] spawn {
	params ["_map", "_margin"];
	private _gs = (getTerrainInfo) select 2;    // metres per height cell
	private _n  = (getTerrainInfo) select 3;    // cells per side
	private _xOff = missionNamespace getVariable ["DTB_xOffset", 200000];
	private _yOff = missionNamespace getVariable ["DTB_yOffset", 0];

	private _minX = 1e9; private _maxX = -1e9;
	private _minY = 1e9; private _maxY = -1e9;
	{
		_minX = _minX min (_x select 0); _maxX = _maxX max (_x select 0);
		_minY = _minY min (_x select 1); _maxY = _maxY max (_x select 1);
	} forEach (keys _map);

	private _x0 = (_minX - _margin) max 0;
	private _x1 = (_maxX + _margin) min (_n - 1);
	private _y0 = (_minY - _margin) max 0;
	private _y1 = (_maxY + _margin) min (_n - 1);
	private _cols = _x1 - _x0 + 1;
	private _rows = _y1 - _y0 + 1;
	private _xll = _xOff + _x0 * _gs;
	private _yll = _yOff + _y0 * _gs;

	[format ["Deformer: exporting %1 x %2 cells (%3 edited points)...", _cols, _rows, count _map], 0] call BIS_fnc_3DENNotification;

	private _lines = [
		format ["ncols %1", _cols toFixed 0],
		format ["nrows %1", _rows toFixed 0],
		format ["xllcorner %1", _xll toFixed 3],
		format ["yllcorner %1", _yll toFixed 3],
		format ["cellsize %1", _gs toFixed 3],
		"NODATA_value -9999"
	];

	for "_iy" from _y1 to _y0 step -1 do {
		private _row = [];
		for "_ix" from _x0 to _x1 do {
			private _k = [_ix, _iy];
			private _h = if (_k in _map) then {
				(_map get _k) select 0
			} else {
				getTerrainHeightASL [_ix * _gs, _iy * _gs]
			};
			_row pushBack (_h toFixed 2);
		};
		_lines pushBack (_row joinString " ");
	};

	diag_log format ["DTB export: heights %1x%2 xll=%3 yll=%4 cell=%5", _cols, _rows, _xll, _yll, _gs];
	private _items = [_lines, "Terrain heights", "heightmap_patch.asc"] call DTB_fnc_queueParts;
	[_items, 0] spawn DTB_fnc_showParts;
};
