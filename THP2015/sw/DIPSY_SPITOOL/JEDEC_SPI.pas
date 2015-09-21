//
// JEDEC SPI Flash support unit
// Detect SPI parameters based on ID
//
unit JEDEC_SPI;

interface

var
  IsDataflash : boolean = false;
  Feature_AAI : boolean = false;
  Feature_PP  : boolean = false;
  PageSize : integer = 256;
  PageCount : integer = 4096; // 2MByte
  JedecVendor : string = 'unknown';
  JedecVendorNum : integer;
  GD_fix: boolean = false;

const
  JEDEC_PAGE0: array[0..125] of String = (
    // 0..9
    '0',
    'AMD',
    'AMI',
    'Fairchild',
    'Fujitsu',
    'GTE',
    'Harris',
    'Hitachi',
    'Inmos',
    'Intel',
    // 10..19
    'I.T.T.',
    'Intersil',
    'Monolithic Memories',
    'Mostek',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 20..
    'd',
    'NXP (Philips)',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'Eon Silicon Devices',
    'd',
    // 30..
    'd',
    'Adesto (Atmel)',
    'ST (SGS/Thompson)',
    'Lattice',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 40..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 50..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 60..
    'd',
    'd',
    'd',
    'SST',
    'd',
    'd',
    'Matrix Semi',
    'd',
    'd',
    'd',
    // 70..
    'd',
    'd',
    'Giga Devices', // C8 wrong PAGE
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 80..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 90..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 100..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 110..
    'd',
    'Winbond (NEXCOM)',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 120..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd'
  );

  JEDEC_PAGE1: array[0..125] of String = (
    // 0..9
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 10..19
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 20..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 39..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 40..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 50..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 60..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 70..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 80..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 90..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 100..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 110..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    'd',
    // 120..
    'd',
    'd',
    'd',
    'd',
    'd',
    'd'
  );

//
// 3 bytes response to 9F command
//
function DetectWithJEDEC(id: cardinal): boolean;

implementation

function DetectWithJEDEC(id: cardinal): boolean;
var
  jedec_page,
  b0, b1, b2: byte;
begin
  GD_Fix := false;

  jedec_page := 0;
  b0 := (id shr 16) and $FF;
  b1 := (id shr  8) and $FF;
  b2 := (id       ) and $FF;

  // check if second page?
  if b0=$7F then
  begin
    jedec_page := 1;

    b0 := b1;
    b1 := b2;
    b2 := 0;

    JedecVendor := JEDEC_PAGE1[b1 and $7F];

  end else begin
    JedecVendor := JEDEC_PAGE0[b0 and $7F];
    JedecVendorNum := b0;
  end;
  // --------------------------------

  IsDataFlash := false;
  Feature_AAI := false;
  Feature_PP  := false;

  PageSize := 0; //

  // guess default sizes (num pages)
  case b2 of
    $13: begin
        PageCount := 512*4;   // 4MBit
    end;
    $14: begin
        PageCount := 1*1024*4; // 8MBit
    end;
    $15: begin
        PageCount := 2*1024*4; // 16MBit
    end;
    $16: begin
        PageCount := 4*1024*4; // 32MBit
    end;
    $17: begin
        PageCount := 8*1024*4; // 64MBit
    end;
  end;

  // go vendor specific types


  case JedecVendorNum of
    //----------
    // eon
    $1C: begin
      Feature_PP  := true;
    end;
    //----------
    // ESMT
    $8C: begin
      case b1 of
        $20: begin
          case b2 of
            $13: begin
              Feature_AAI  := true;
            end;
            $14: begin
              Feature_AAI  := true;
              // not always!
              //Feature_PP  := true;
            end;
            $15: begin
              Feature_AAI  := true;
              // not always!
              //Feature_PP  := true;
            end;
            $16: begin
              Feature_PP  := true;
            end;
          end;
        end;
        $30: begin
          case b2 of
            // -- F2S04PA
            $13: begin
              Feature_PP  := true;
            end;
          end;
        end;
        $40: begin
          case b2 of
            $16: begin
              Feature_PP  := true;
            end;
          end;
        end;
      end;
    end;
    //----------
    // Matrix
    $C2: begin
      //
      Feature_PP  := true;
      GD_Fix := True;

    end;

    //----------
    // GigaDevice
    $C8: begin
      // something weird?
      Feature_PP  := true;
      GD_Fix := True;

    end;
    //----------
    // NEXCOM(winbond)
    $EF: begin
      case b1 of
        $40: begin
          case b2 of
            $15: begin
              Feature_PP  := true;
            end;
            $17: begin
              Feature_PP  := true;
            end;
            $18: begin
              Feature_PP  := true;
            end;


          end;
        end;
      end;
    end;
    // SST
    $BF: begin
      case b1 of
        $25: begin
          case b2 of
            $41: begin
              Feature_AAI  := true;
            end;
          end;
        end;
      end;
    end;
    // Atmel
    $1F: begin
      case b1 of
        // AT45DB081D
        $25: begin
          case b2 of
            $00: begin
              IsDataFlash := True;
              PageCount := 1*1024*2; // 8MBit
              PageSize := 512; // default!
            end else begin
              // warning?
            end;
          end;
        end;
        // AT45DB161D
        $26: begin
          case b2 of
            $00: begin
              IsDataFlash := True;
              PageCount := 2*1024*2; // 8MBit
              PageSize := 512; // default!
            end else begin
              // warning?
            end;
          end;
        end;
        // AT25DF641
        $48: begin
          case b2 of
            $00: begin
              //IsDataFlash := True;
              PageCount := 8*1024*4; // 64MBit
              PageSize := 256; // default!
              Feature_PP  := true;
            end else begin
              // warning?
            end;
          end;


        end else begin
          // unknown Atmel device ?

        end;
      end;
    end;


    //----------

  end;

  if PageSize=0 then PageSize := 256; //


end;

end.
