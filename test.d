/*
 * inigear.d
 *
 * Copyright 2012 Igor Solkin
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

import std.stdio;
import std.string;
import std.ascii;
import std.file;

import inigear;

int main(char[][] args)
{
	IniGear iniGear = new IniGear();
	// IniGroup 1
	IniGroup iniGroup1 = new IniGroup("Фрукты");
	iniGroup1.addItem("Апельсин", "Оранжевый");
	iniGroup1.addItem("Персик", "Шерстяной");
	iniGroup1.addItem("Банан", "Жёлтый");
	// IniGroup 2
	IniGroup iniGroup2 = new IniGroup("Овощи");
	iniGroup2.addItem("Помидор", "Красный");
	iniGroup2.addItem("Картофель", "Жёлтый");
	iniGroup2.addItem("Огурец", "Зелёный");
	// IniGroup 3
	IniGroup iniGroup3 = new IniGroup("Инструменты");
	iniGroup3.addItem("Отвёртка", "Железная");
	iniGroup3.addItem("Разводник", "Тяжёлый");
	iniGroup3.addItem("Кусачки", "Острые");

	iniGear.addGroup(iniGroup1);
	iniGear.addGroup(iniGroup2);
	iniGear.addGroup(iniGroup3);

	writeln(iniGear.serialize());
	writeln("---");

	IniFile.write("test.ini", iniGear);

	//writeln(iniGear.getGroup("Овощи").getItem("Картофель").getValue());
	/*IniItem t_item = new IniItem("Ключ=Значение");
	writeln(t_item.serialize);
	auto data = q{[Группа]
Ключ=Значение
Это=Да
И=Это
Ещё=Вот это};
	writeln(data);
	iniGroup3.deserialize(data);
	writeln("---");
	writeln(iniGroup3.serialize);*/

	/*IniGear t_iniGear = new IniGear();
	t_iniGear.deserialize(iniGear.serialize);
	writeln(t_iniGear.serialize());*/

	IniGear fileGear = IniFile.read("test.ini");
	writeln(fileGear.serialize);
	writeln("---");
	return 0;
}
