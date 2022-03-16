
# SkyrimCompiler

This is a very early work-in-progress.

The objective is to product a library (and command line tool), which can take a directory structure composed of text "source" files, and compile it into an `.esp` file. The reverse direction (`.esp` to source) is also an essential step and will be supported.

Given the complexity of the format, the initial goal is not to support direct editing of every single record type.

Parsing of specific record and field types will be slowly expanded, but a fallback option will take the binary content of unknown fields and convert them to/from hex-encoded text.

The advantage of this approach is that round-tripping can be implemented quite cheaply (it is already working, in fact), whereas full support for every single field and record type will take months or years of work.

## Primary Goals

One motivation for this tool is to enable esp development to be managed by source control.

Another is to allow a simple way to perform small manual edits to an esp.

However, probably the primary motivation is to enable easier development of other tools.

By removing the need to parse and understand the binary format, it should be simpler to produce tools
which can:

- generate esps
- extract items from esps
- modify specific record types

This should make it easier to develop small focussed tools that have a specific purpose. Hopefully that will lower the entry barrier for tool development, which is currently pretty high (tools like xEdit or CreationKit are enourmous monsters).

## Secondary Goals

The code is written in Swift*, which is primarily known as a language used to develop iOS/macOS apps. I aim to make it fully cross-platform however. This may be of more interest in the context of OpenMW than it is for Skyrim modders, but as a relatively low-level library, there seems no reason why it couldn't be platform neutral.

The hope is that tools can just read/write the text format, and then invoke this compiler. However, it also makes sense to supply the functionality as a shared library / dll, so I aim to do that.

Where possible, the textual file format will aim to hide complexity of the underlying binary file format. As a trivial example, if you've got an array of something, the binary format will probably also have a count stored alongside it; the textual file format won't need this, and can generate the count during compilation. 

There are far more complex examples where the binary format changes based on context (version number, for example). In this case the text format will hide the complexity where it can, and provide a higher-level abstraction which can be decompiled/recompiled. Hopefully a side-effect of this will be a clean way to upgrade an old ESP to use the newest binary encoding.

All of this is really a means to an end - in that there are other tools that I want to write which will sit on top of this. As such, I aim to make the code in this library as accessible as possible, whilst still trying to keep the scope as narrow as possible.

(* because that's what I use in my day job)

### See Also

The ultimate reason for doing all of this is to make some tools.

There are a number of tools that I have in mind, but the main one right now is something that provides a better way to install clothing/armour packs.

The idea is to make a new way for authors to package up and publish just the basic resources for a piece of clothing or armour (models, textures, presets, etc). 

The user of the tool will then be able to install as many of these packs as they want. They will be able to select which items to include in the game. In addition the tool will take over responsibility for choosing how the items are delivered to the user, whether they are craftable, added to levelled lists, and so on.

Once the user has made their choices, the tool will compile all of the clothing data into a single mod which can be installed/enabled in the normal way.

This idea has some similarities to the way [EasyNPC](https://github.com/focustense/easymod/tree/master/Focus.Apps.EasyNpc) works, but with the addition of being a distribution platform.

### File Format

This is currently JSON based, with a file for each record, and directories for (sub)groups. 

The choice of JSON is not final, but it was easy to start with. 

The primary objective for the file format is not human-readability, but that doesn't mean that it wouldn't be nice.

I am also considering an embedded DSL, since Swift has good support for such things. I don't really want people to be reliant on the Swift toolchain however, which pushes me heavily away from that direction.

### Not Just Skyrim

I'm initially focussed on Skyrim SE/AE, because that's what I play. In theory though this tool could support the whole family of games using `.esp` files.

In particular, adopting a tool like this for OpenMW might make a lot more sense than trying to reproduce CreationKit warts-and-all.

### Similar Projects

There are at least a couple of projects aiming at similar things:

- https://github.com/Greatness7/tes3conv
- https://gitlab.com/bmwinger/delta-plugin

I didn't know about them when I started mine, and of course we all have our own agendas, motivations, areas of expertise and language preferences. 

That said, I'd be up for collaborating if we could figure out some places where it would make sense.

### References

- ESP File format: https://en.uesp.net/wiki/Skyrim_Mod:Mod_File_Format
- Data Types: https://en.uesp.net/wiki/Skyrim_Mod:File_Format_Conventions
- Pyffi definitions (incomplete): https://github.com/niftools/pyffi/blob/develop/pyffi/formats/esp/esp.xml

### Related Projects

As part of that work, I'm also making:

- [a Swift library to pack/unpack BSA files](https://github.com/elegantchaos/SwiftBSA).
- [a Swift library to pack/unpack ESP files](https://github.com/elegantchaos/SwiftESP).
- [a Swift library to work with NIF files](https://github.com/elegantchaos/SwiftNIF).

### Example Data

The example data in this repo is taken from [Parapets](https://www.nexusmods.com/skyrimspecialedition/users/39501725), who helpful makes all their mods available under an MIT license.
