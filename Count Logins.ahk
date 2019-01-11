File_List =
User_List =
Login_Count =
User_Count =
Loop, Files, *.csv, F
    File_List = %File_List%%A_LoopFileName%`n
Loop, Parse, File_List, `n
{
    User_List = %User_List%%A_LoopField%
    Loop, Read, %A_LoopField%
    {
    Login_Count = %A_Index%
    }
    if (A_LoopField != "")
        User_List = %User_List%:%A_Space%%Login_Count%`n
}

Loop, Parse, User_List , ":"
{
    User_Count = %A_Index%
}
msgbox, %User_List%`n`nUsers: %User_Count%