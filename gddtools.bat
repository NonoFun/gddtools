::MagickBatcher V0.5.6
::Script made by NonoFun


@echo off
cls
setlocal enabledelayedexpansion
::echo %~dp0
::echo %cd%
set dossierchoix=2
goto :setup


:jpgcustom
for %dossier% %%a in (*.jpg) do %~dp0bin\ImageMagick\mogrify -profile %~dp0config\sRGB2014.icc -resize %largeur%x%hauteur% -gravity center -extent 600x600 -interlace Plane -strip -define jpeg:extent=120kb "%%~a"
@exit /b


:setup
echo.
echo ----------------------------------------------
echo Dossier actuel : %cd%
echo ----------------------------------------------
echo.

echo Selectionner un mode de traitement:
echo Travailler ^| Recursivement (dossier actuel et sous dossier) ou ^| Localement (dossier actuel) ^?
echo 		(1) Recursif	(2) Locale [Defaut]
echo.
set /p dossierchoix=Ma saisie :

if %dossierchoix% EQU 1 (
	echo.
	echo ----- Recursivement -----
	set dossierecho=Recursive
	set "dossier=/r"
	set "fichier=/s"
	goto :debut
	
) else (
	echo.
	echo ----- Localement -----
	set dossierecho=Local
	set "dossier= "
	set "fichier= "
	goto :debut
)


:debut
echo.
echo -------------------------------------
echo == Pharma-GDD batch converter v0.5.6 FR ==
echo -------------------------------------
echo.
echo Dossier actuel : %cd%
echo Configuration du mode de traitement des images : %dossierecho%
echo.
echo Qu'aimeriez-vous faire ^?
echo 	(1) Cropper et ajuster PNG et/ou JPG sur fond blanc
echo 	(2) Convertir PNG/WEBP vers JPG 100%%
echo 	(3) Convertir vers JPG avec marge predefini 600x600px ^| 120kb
echo 	(4) Convertir vers JPG 600x600px ^| 120kb
echo 	(5) Supprimer un type de fichier
echo 	(6) Convertir vers JPG [marge custom] 600x600px ^| 120kb
echo 	(7) Efixtool (Outil pour juste supprimer les metadonnees)
echo.
set /p choix=Ma saisie : 


if %choix% EQU 1 (
	echo -----(1^)Croppage PNG/WEBP/JPG ajuste -----
	echo on
	for %dossier% %%a in (*.png,*.webp,*.jpg,*.jpeg) do %~dp0bin\ImageMagick\mogrify -trim +repage "%%~a"
	set resultat=1
	
) else if %choix% EQU 2 (
	echo -----(2^)Conversion vers JPG 100%% -----
	echo on
	for %dossier% %%a in (*.png,*.webp) do %~dp0bin\ImageMagick\mogrify -format jpg -background white -flatten -quality 100%% "%%~a"
	set resultat=2
	
) else if %choix% EQU 3 (
	echo -----(3^)Conversion vers JPG avec marge 600x600 120kb -----
	echo on
	for %dossier% %%a in (*.jpg) do %~dp0bin\ImageMagick\mogrify -profile %~dp0config\sRGB2014.icc -resize 540x540 -gravity center -extent 600x600 -interlace Plane -strip -define jpeg:extent=120kb "%%~a"
	set resultat=4
	
) else if %choix% EQU 4 (
	echo -----(4^)Conversion vers JPG 600x600 120kb -----
	echo on
	for %dossier% %%a in (*.jpg) do %~dp0bin\ImageMagick\mogrify -profile %~dp0config\sRGB2014.icc -resize 600x600 -gravity center -extent 600x600 -interlace Plane -strip -define jpeg:extent=120kb "%%~a"
	set resultat=3
	
) else if %choix% EQU 5 (
	echo.
	echo Type de fichier a supprimer ^^!
	echo 	Chosir (1^) pour png
	echo 	Chosir (2^) pour webp
	echo 	Chosir (3^) pour jpg
	echo 	Chosir (4^) pour mp4
	echo 	Chosir (5^) pour mov
	echo 	Chosir (6^) pour pdf
	echo 	"Tapez l'extention que vous voulez si celle-la ne figure pas dans la liste."
	echo.
	set /p extention=Ma saisie : 
	if !extention! EQU 1 (set extention=png
	) else if !extention! EQU 2 (set extention=webp
	) else if !extention! EQU 3 (set extention=jpg
	) else if !extention! EQU 4 (set extention=mp4
	) else if !extention! EQU 5 (set extention=mov
	) else if !extention! EQU 6 (set extention=pdf)
	echo -----(5^)Suppression des .!extention! -----
	for %dossier% %%a in (*.!extention!) do (
		del "%%a"
		echo %%a supprimer.
	)
	set resultat=5
	
) else if %choix% EQU 6 (
	echo.
	echo.Saisissez les valeurs que vous souhaitez pour redimensionner l'image ^^!
    set /p largeur=Largeur en pixel : 
	set /p hauteur=Hauteur en pixel : 
	echo -----(6^)Conversion vers JPG avec marge custom !largeur!x!hauteur! 120kb-----
	echo on
	call :jpgcustom
	set resultat=6
	
) else if %choix% EQU 7 (
	echo -----(7^)Suppression des metadonnees -----
	echo on
	for %dossier% %%a in (*.*) do %~dp0bin\exiftool -r -all= -overwrite_original "%%~a"
	set resultat=7
	
)

@echo off
if %resultat% EQU 1 (
	echo.
	echo ===== Trimming done ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 2 (
	echo.
	echo ===== Finished Convert to JPG 100%% finish ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 3 (
	echo.
	echo ===== Finished JPG default margin 600x600 120kb finish ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 4 (
	echo.
	echo ===== Finished JPG 600x600 120kb finish ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 5 (
	echo.
	echo ===== Finished deleting .!extention! ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 6 (
	echo.
	echo ===== Finished JPG custom margin %largeur%x%hauteur% 120kb ^^!^^!^^! =====
	echo.
) else if %resultat% EQU 7 (
	echo.
	echo ===== Metadata removed ^^!^^!^^! =====
	echo.
)

	echo.
	goto :debut
pause