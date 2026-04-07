module ZBox
    #=============================================================================================================
    # Ejemplo de palette_swap:
    # Example of palette_swap:
    #
    # Necesitas crear una imagen de 2 píxeles de alto.
    # El ancho dependerá de la cantidad de colores que quieras cambiar en la paleta.
    # Los colores originales irán en la primera fila y los colores que los reemplazarán en la segunda.
    # NOTA: Aunque el script tiene cierta tolerancia, creado para los iconos, ten en cuenta que si quieres
    # que la línea evolutiva, formas, iconos y sus versiones shiny tengan una continuidad, tendrás que agregar
    # también sus paletas junto al color que la remplazará. Si no se hace, la tolerancia encotrará colores
    # parecidos, pero el resultado no será el ideal.
    #
    # You need to create an image 2px high.
    # The width will depend on the number of colors you want to change in the palette.
    # The original colors will go in the first row and the colors that will replace them in the second.
    # NOTE: Although the script has a certain tolerance, created for the icons, keep in mind that if you
    # want the evolutionary line, forms, icons and their shiny versions to have continuity, you'll also need to
    # add their color palettes along with the color that will replace them. If you don't, the tolerance
    # will find similar colors, but the result won't be ideal.
    #=============================================================================================================

    # NOTA: NO SE RECOMIENDA SU USO SI TIENE EL DBK ANIMATED POKÉMON SYSTEM,
    # YA QUE CUANTO MÁS GRANDE SEA EL SPRITESHEET, MÁS TIEMPO TARDARÁ EN APLICARSE
    # O INCLUSO PODRÍA CRASHEAR JUEGO.

    # NOTE: NOT RECOMMENDED FOR USE IF YOU HAVE THE DBK ANIMATED POKÉMON SYSTEM,
    # BECAUSE THE LARGER THE SPRITESHEET, THE LONGER IT WILL TAKE TO APPLY OR
    # IT MAY EVEN CRASH THE GAME


    # Se puede llamar mediante un evento con: ZBox.give_bulbasaur_dry
    # Can be called from an event with: ZBox.give_bulbasaur_dry
    def self.give_bulbasaur_dry
      bulbasaur_data = {
        species: :BULBASAUR,
        level: 30,
        nickname: "Dry",
        poke_ball: :ULTRABALL,

        # --- Palette Swap ---
        # Se asume que existe un archivo "BULBASAUR_DRY" en
        # la carpeta "Graphics/Plugins/Pokemon Factory/Palettes/".

        # It is assumed that a file "BULBASAUR_DRY" exists in
        # the "Graphics/Plugins/Pokemon Factory/Palettes/" folder.
        palette_swap: "DRY"
      }

      pkmn = PokemonFactory.create(bulbasaur_data)
      pbAddPokemonWithNickname(pkmn)
    end
end
