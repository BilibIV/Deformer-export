class CfgPatches
{
	class DTB_DeformerExport
	{
		name = "Deformer -> Terrain Builder Export";
		author = "DTB";
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_UI_F","3DEN","A3_3DEN","GF_Deformer"};
	};
};

class CfgFunctions
{
	class DTB
	{
		class Export
		{
			file = "DTB_DeformerExport\functions";
			class getGridMap {};
			class queueParts {};
			class showParts {};
			class exportHeights {};
			class exportObjects {};
		};
	};
};

class ctrlMenuStrip;
class Display3DEN
{
	class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
				// pin our submenu inside the existing Tools > Deformer menu
				class GF_deform
				{
					items[] += {"DTB_export"};
				};
				class DTB_export
				{
					text = "Export to Terrain Builder";
					items[] = {"DTB_exportHeights","DTB_exportObjConv","DTB_exportObjAll"};
				};
				class DTB_exportHeights
				{
					text = "Edited terrain  ->  heightmap patch (.asc)";
					action = "[] call DTB_fnc_exportHeights";
				};
				class DTB_exportObjConv
				{
					text = "Converted objects  ->  TB import (+ delete list)";
					action = "['converted'] call DTB_fnc_exportObjects";
				};
				class DTB_exportObjAll
				{
					text = "All editor objects  ->  TB import";
					action = "['all'] call DTB_fnc_exportObjects";
				};
			};
		};
	};
};
