classdef leptonJetVar < uint8
  % LeptonJet variable map 1..25 -> 'Apla','Spher',...
  %   leptonJetVar(1).toString == leptonJetType.Apla == 'Apla'
  
  enumeration
    Apla (1),
    Spher (2),
    HTL (3),
    JetMt (4),
    HT3 (5),
    MEvent (6),
    MT1NL (7),
    M01mall (8),
    M0nl (9),
    M1nl (10)
    Mt0nl (11)
    Met (12),
    Mtt (13),
    Mva_max (14),
    Wmt (15)
    Wpt (16),
    Centr (17),
    DRminejet (18),
    DiJetDrmin (19),
    Ht (20),
    Ht20 (21),
    Ktminp (22),
    Lepdphimet (23), 
    Lepemv (24),
    Jetm (25)
  end
  methods
    function str = toString(obj)
      str = char(obj);
    end
    function [a b] = histInterval(obj,njets, particle)
      ints = [...
        1	0	0.2	0	0.3	0	0.35	0	0.2	0	0.3	0	0.35	; ...
        2	0	1	0	1	0	1	0	1	0	1	0	1	; ...
        3	50	500	50	600	50	600	0	500	50	600	50	600	; ...
        4	50	500	50	600	50	650	0	500	50	600	50	650	; ...
        5	nan	nan	15	100	35	150	nan	nan	15	100	35	150	; ...
        6	0	750	0	750	0	800	0	750	0	750	0	800	; ...
        7	0	500	0	500	0	500	0	500	0	500	0	500	; ...
        8	0	1.5	0	1.5	0	1.5	0	1.5	0	1.5	0	1.5	; ...
        9	0	500	0	500	0	550	0	500	0	500	0	550	; ...
        10	0	400	0	500	0	500	0	400	0	500	0	500	; ...
        11	0	600	0	600	0	600	0	600	0	600	0	600	; ...
        12	0	200	0	250	0	250	0	200	0	250	0	250	; ...
        13	50	750	0	800	0	1000	50	750	0	800	0	1000  ; ...
        14	0	1	0	1	0	1	0	1	0	1	0	1	; ...
        15	0	200	0	200	0	200	0	200	0	200	0	200	; ...
        16	0	250	0	250	0	250	0	250	0	250	0	250	; ...
        17	0.1	1	0.1	1	0.1	1	0.1	1	0.1	1	0.1	1	; ...
        18	0.5	4	0.5	3.5	0.5	3	0.5	4	0.5	3.5	0.5	3	; ...
        19	0.5	4	0.5	3.5	0.5	2.5	0.5	4	0.5	3.5	0.5	2.5	; ...
        20	50	350	50	500	50	500	50	350	50	500	50	500	; ...
        21	0	600	0	600	0	700	0	600	0	600	0	700	; ...
        22	0	6	0	2.5	0	1.6	0	6	0	2.5	0	1.6	; ...
        23	0	3.142	0	3.142	0	3.142	0	3.142	0	3.142	0	3.142	; ...
        24	-1	1	-1	1	-1	1	-1	-1	-1	-1	-1	-1	; ...
        25	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	nan	; ...
        ];
      offset = 6*(particle-1) + 2*(njets - 2) + 2;
      a = ints(obj, offset);
      b = ints(obj, offset + 1);
    end
  end
  methods(Static)
    function all = getAll()
      % returns vector of all types without data
      n = leptonJetVar.numTypes;
      all(n,1) = leptonJetVar(n);
      for k = 1:n-1
        all(k) = leptonJetVar(k);
      end
    end
    function n = numTypes()
      n = 25;
    end
    function all = getAllStrings()
      % returns vector of all types without data
      n =24;% leptonJetVar.numTypes;
      all = cell(n-1,1);
      for k = 1:n-1
        aaa = leptonJetVar(k);
        all{k} = aaa.toString;
      end
    end
  end
end

