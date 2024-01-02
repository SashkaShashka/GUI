bulk insert gui_base.dbo.gui_table
from 'C:\Users\sasha\Desktop\Labs\DesignGUI-main\LabWork_3\output.txt'
    with
    (
	datafiletype = 'widechar',
    fieldterminator = '|',
    rowterminator = '\n'
    );