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

public class IniItem {
	private string key;
	private string value;
	public static const char PAR_SYMBOL = '=';

	this(string data) {
		deserialize(data);
	}

	this(string key, string value) {
		setKey(key);
		setValue(value);
	}

	public void setKey(string key) {
		this.key = key;
	}

	public string getKey() {
		return key;
	}

	public void setValue(string value) {
		this.value = value;
	}

	public string getValue() {
		return value;
	}

	public string serialize() {
		return getKey() ~ PAR_SYMBOL ~ getValue();
	}

	public void deserialize(string data) {
		ulong parIndex = indexOf(data, PAR_SYMBOL);
		setKey(data[0 .. parIndex]);
		setValue(data[parIndex + 1 .. $]);
	}
}

public class IniGroup {
	private string name;
	private IniItem[string] items;
	public static const char LEFT_COMMA_SYMBOL = '[';
	public static const char RIGHT_COMMA_SYMBOL = ']';

	this() {
	}

	this(string name) {
		setName(name);
	}

	public void setName(string name) {
		this.name = name;
	}

	public string getName() {
		return name;
	}

	public void addItem(string data) {
		addItem(new IniItem(data));
	}

	public void addItem(string key, string value) {
		addItem(new IniItem(key,value));
	}

	public void addItem(IniItem iniItem) {
		items[iniItem.getKey()] = iniItem;
	}

	public IniItem getItem(string key) {
		return items[key];
	}

	public IniItem[] getValues() {
		return items.values;
	}

	public string[] getKeys() {
		return items.keys;
	}

	public void removeItem(string key) {
		items.remove(key);
	}

	public ulong getItemsCount() {
		return items.length();
	}

	public string serialize() {
		string data = LEFT_COMMA_SYMBOL ~ name ~ RIGHT_COMMA_SYMBOL;
		for(int c=0; c < items.length; c++) {
			data ~= newline ~ items.values[c].serialize;
		}
		return data;
	}

	public void deserialize(string data) {
		deserialize(splitLines(data));
	}

	public int deserialize(string[] lines) {
		items = items.init;
		if(lines.length > 0) {
			string group = lines[0];
			if(assertIsGroup(group)) {
				setName(group[1 .. $ - 1]);
				int c;
				while (++c < lines.length
					&& !assertIsGroup(lines[c])) {
					addItem(lines[c]);
				}
				return c;
			}
		}
		return 0;
	}

	public static bool assertIsGroup(string line) {
		return line[0] == LEFT_COMMA_SYMBOL
				&& line[$ - 1] == RIGHT_COMMA_SYMBOL;
	}
}

public class IniGear {

	private IniGroup[string] groups;

	public void addGroup(string name) {
		addGroup(new IniGroup(name));
	}

	public void addGroup(IniGroup iniGroup) {
		groups[iniGroup.getName()] = iniGroup;
	}

	public IniGroup getGroup(string key) {
		return groups[key];
	}

	public string[] getGroupNames() {
		return groups.keys;
	}

	public IniGroup[] getGroups() {
		return groups.values;
	}

	public void removeGroup(string key) {
		groups.remove(key);
	}

	public ulong getGroupsCount() {
		return groups.length();
	}

	public string serialize() {
		string data = "";
		for(int c=0;c<groups.length;c++){
			data ~= groups.values[c].serialize;
			if(c < groups.length - 1) {
				data ~= newline;
			}
		}
		return data;
	}

	public void deserialize(string data) {
		groups = groups.init;
		string[] lines = splitLines(data);
		if(lines.length > 0) {
			ulong c = 0;
			do {
				IniGroup iniGroup = new IniGroup();
				c += iniGroup.deserialize(lines[c .. $]);
				addGroup(iniGroup);
			} while(c < lines.length);
		}
	}
}

public class IniFile {

	public static IniGear read(string path) {
		IniGear iniGear = new IniGear();
		iniGear.deserialize(readText(path));
		return iniGear;
	}

	public static void write(string path, IniGear iniGear) {
		//File file = File(path, "w");
		//file.write(iniGear.serialize);
		//file.flush();
		//file.close();
		std.file.write(path, iniGear.serialize());
	}
}

