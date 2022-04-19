# qb-recyclejob
QBCore Recycle Job - Rework by xThrasherrr

MODIFIED BY: Thrasherrr#9224

REWORKED TO INCLUDE CONFIG VALUES

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------




- Add this item to your shared items

`['recycledmaterials'] 			 = {['name'] = 'recycledmaterials', 			['label'] = 'Recycled Materials', 		['weight'] = 500, 		['type'] = 'item', 		['image'] = 'recycledmaterials.png', 	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Look at you, saving the earth!'},`


- Add this wherever you spawn your peds

        { -- RECYCLING CENTER PED
            model = 's_m_y_xmech_02',
            coords = vector4(-572.4, -1632.1, 18.41, 168.63),
            gender = 'male',
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            freeze = true,
            invincible = true,
            blockevents = true
        },


You can change how much materials each recycled material gives you in the config file.

There is still a random chance to obtain crypto sticks.


At some point, I will remove the 3D Draw Text in the recycling center and convert to draw text or target based.


KNOWN ISSUE(S):

If you trade all, and don't have the space in your pockets, it will still take your recycled materials and not give you any in return.

![image](https://user-images.githubusercontent.com/101474430/163911870-a4aa3f74-dbcc-4dd8-8fda-bcd0c2f4c327.png)
![image](https://user-images.githubusercontent.com/101474430/163911905-d2d3c1d4-7ec4-4564-9206-2e217e981ca5.png)
![image](https://user-images.githubusercontent.com/101474430/163911897-1031b668-41bb-49f1-93a9-e245a0bad4a3.png)



---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
