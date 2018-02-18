@echo off

if exist GrapeSodaOS.hdd del GrapeSodaOS.hdd

echo Assembling the bootloader...
nasm source\bootsect.asm -o bin\bootsect.sys

echo Creating the disk image...
type bin\bootsect.sys>> GrapeSodaOS.hdd