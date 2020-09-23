Attribute VB_Name = "TransBkText"
Option Explicit

Private Const COLOR_BACKGROUND = 1
Private Const LVM_FIRST = &H1000 'ListView messages
Private Const LVM_GETTEXTCOLOR = (LVM_FIRST + 35)
Private Const LVM_SETTEXTCOLOR = (LVM_FIRST + 36)
Private Const LVM_GETTEXTBKCOLOR = (LVM_FIRST + 37)
Private Const LVM_SETTEXTBKCOLOR = (LVM_FIRST + 38)

Private Const CLR_NONE = &HFFFFFFFF
Private Const RED = &HFF

Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long

Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Private Declare Function GetSysColor Lib "user32" (ByVal nIndex%) As Long

Private Declare Function InvalidateRect Lib "user32" (ByVal hwnd As Long, lpRect As Any, ByVal bErase As Long) As Long

Private Declare Function UpdateWindow Lib "user32" (ByVal hwnd As Long) As Long

Private Sub Main()
        Dim bRet As Boolean
        Dim lProgman As Long
        Dim lSHELLDLLDefView As Long
        Dim lSysListView32 As Long
        '
        'Get the handle to the top level window with a class name of
        '"Progman" and caption of "Program Manager".
        '
        lProgman = FindWindow("Progman", "Program Manager")
        If lProgman = 0 Then Exit Sub
        '
        'Get Program Manager's child window which has
        'a class name of "SHELLDLL_DefView".
        '
        lSHELLDLLDefView = FindWindowEx(lProgman, 0&, "SHELLDLL_DefView", vbNullString)
        If lSHELLDLLDefView = 0 Then Exit Sub
        '
        'Now get this window's child.
        '
        lSysListView32 = FindWindowEx(lSHELLDLLDefView, 0&, "SysListView32", vbNullString)
        If lSysListView32 = 0 Then Exit Sub
        '
        'Get the current background color. If it is not CLR_NONE
        '(no background color) set it so. If it is, set the current
        'background color.
        '
        If (ListView_GetTextBkColor(lSysListView32) <> CLR_NONE) Then
           bRet = ListView_SetTextBkColor(lSysListView32, CLR_NONE)
        Else
           Call ListView_SetTextBkColor(lSysListView32, GetSysColor(COLOR_BACKGROUND))
        End If
        '
        'Add a rectangle to the listview's update region. This is the portion of
        'the window's client area that must be redrawn. The 0 parameter tells
        'it to redraw the entire client area.
        '
        Call InvalidateRect(lSysListView32, ByVal 0&, True)
        '
        'Send a WM_PAINT message to the listview to force
        'it to redraw itself
        '
        Call UpdateWindow(lSysListView32)
        End
End Sub

Private Function ListView_SetTextBkColor(hwnd As Long, clrTextBk As Long) As Boolean
        Dim lRet As Long

        lRet = SendMessage((hwnd), LVM_SETTEXTBKCOLOR, 0&, clrTextBk)
        'lRet = SendMessage((hwnd), LVM_SETTEXTCOLOR, 0&, RED) 'Red Text
        'lRet = SendMessage((hwnd), LVM_SETTEXTCOLOR, 0&, &H0) 'Black Text
        'lRet = SendMessage((hwnd), LVM_SETTEXTCOLOR, 0&, &HFFFFFF) 'White text

        If lRet = 0 Then
            ListView_SetTextBkColor = False
        Else
            ListView_SetTextBkColor = True
        End If
End Function

Private Function ListView_GetTextBkColor(hwnd As Long) As Long
        ListView_GetTextBkColor = SendMessage((hwnd), LVM_GETTEXTBKCOLOR, 0, 0)
End Function

