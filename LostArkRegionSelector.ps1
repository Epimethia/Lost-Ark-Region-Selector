# Gets the current location and uses it to find the XML file
$CurrentPath = Get-Location
$UserOptionPath = "$CurrentPath\EFGame\Config\UserOption.xml"

# Test Load the XML File.
[xml]$xml = Get-Content $UserOptionPath

if (!$xml) {
    Write-Output "Failed to get XML File. File not found at $UserOptionPath"
    exit
}

#Creating the window to hold all the options
Add-Type -assembly System.Windows.Forms
$window = New-Object System.Windows.Forms.Form
$window.Text = "LA Region Switcher"
$window.Width = 185
$window.Height = 155
$window.FormBorderStyle = "Fixed3D"
$window.MaximizeBox = $false
$window.MinimizeBox = $false
$window.windows

# Creating the ok button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(10,90)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'Start Game'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$window.AcceptButton = $okButton
$window.Controls.Add($okButton)

# Creating Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(90,90)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$window.CancelButton = $cancelButton
$window.Controls.Add($cancelButton)

# Creating the Drop-down menu for the region changes
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,10)
$listBox.Size = New-Object System.Drawing.Size(155,20)
$listBox.Height = 80

$arr_regions = @{
    "NA West" = "WA"
    "NA East" = "EA"
    "South America" = "SA"
    "EU West" = "WE"
    "EU Central" = "CE"
}

foreach ($region in $arr_regions.GetEnumerator()) {
    [void] $listBox.Items.Add([String]$region.Key)
}

$window.Controls.Add($listBox)


# Display the window
$result = $window.ShowDialog()

# Process the result, and start the game with the desired region
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $arr_regions[$listBox.SelectedItem]
    
    $xml.UserOption.SaveAccountOptionData.RegionID = [String]$x
    $xml.Save($UserOptionPath)
    Write-Output $xml.UserOption.SaveAccountOptionData.RegionID
    start steam://rungameid/1599340
}