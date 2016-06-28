%%
%% This is file `drexel-thesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% drexel-thesis.dtx  (with options: `class')
%% 
%% This is a generated file.
%% 
%% Copyright (C) 2010 W. Trevor King
%% 
%% This file may be distributed and/or modified under the conditions of
%% the LaTeX Project Public License, either version 1.3 of this license
%% or (at your option) any later version.  The latest version of this
%% license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%% and version 1.3 or later is part of all distributions of LaTeX version
%% 2003/06/01 or later.
%% 
\def\fileversion{0.15}
\def\filedate{2013/05/21}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{drexel-thesis}
 [\filedate\ \fileversion\ Drexel Thesis]
\RequirePackage{xkeyval}
\newif\if@mainmatter \@mainmattertrue
\newif\if@DUT@subfigopt
\newif\if@DUT@pagebreak
\newif\if@dottedchapter
\newif\if@boldchapter
\newif\if@boldpart
\newif\if@dottedpart
\newif\if@indenttoc
\newif\if@blackref
\newif\if@draftwatermark
\newif\if@xdraftwatermark
\newif\if@indentfirst
\newif\if@final
\newif\if@daring
\newif\if@approvalform
\newcommand\iffinal[2]{\if@final #1\else #2\fi}
\let\DUTiffinal\iffinal
\newcommand\ifdraftwatermark[2]{\if@draftwatermark #1\else #2\fi}
\let\DUTifdraftwatermark\ifdraftwatermark
\newcommand\ifdaring[2]{\if@daring #1\else #2\fi}
\let\DUTifdaring\ifdaring
\newcommand\DUT@makeapprovalform{
  \thispagestyle{empty}
  \begingroup
  \newlength{\tempskipa}
  \newlength{\tempskipb}
  \parindent \z@
  \settowidth{\tempskipa}{\drexellogobw}
  \addtolength{\tempskipa}{1em}
  \setlength{\tempskipb}{\textwidth}
  \addtolength{\tempskipb}{-\tempskipa}
  \addtolength{\tempskipb}{-1em}
  \begin{minipage}[c]{\tempskipa}
    \raisebox{-0.5\height}{\drexellogobw}
  \end{minipage}
  \hfill
  \begin{minipage}[c]{\tempskipb}
    \textbf{\Huge Office of Graduate Studies} \linebreak
    \vskip 0.1\baselineskip
    \textbf{\LARGE Dissertation / Thesis Approval Form} \linebreak
  \end{minipage}

  \vskip 2\baselineskip

  This form is for use by all doctoral and master's students with a
  dissertation/thesis requirement.  Please print clearly as the
  library will bind a copy of this form with each copy of the
  dissertation/thesis.  All doctoral dissertations must conform to
  university format requirements, which is the responsibility of the
  student and supervising professor.  Students should obtain a copy of
  the Thesis Manual located on the library website.

  \vspace*{\fill}
  \settowidth{\tempskipb}{Dissertation/Thesis Title:}
  \setlength{\tempskipa}{\textwidth}
  \addtolength{\tempskipa}{-\tempskipb}
  \addtolength{\tempskipa}{-4em}
  \begin{spacing}{2}
    \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} l p{\tempskipa}}
      \textbf{Dissertation/Thesis Title:} & \@DUT@title \\
      \textbf{Author:} & \@DUT@author
    \end{tabular*}

    \vspace*{\fill}

    \begin{center}
      \textbf{This dissertation/thesis is hereby accepted and approved.}
    \end{center}

    \vspace*{\fill}

    \textbf{Signatures:} \\
    Examining Committee \\
    \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} p{0pt} l p{\tempskipa}}
      & Chair            & \hrulefill \\
      & Members          & \hrulefill \\
      &                  & \hrulefill \\
      &                  & \hrulefill \\
      &                  & \hrulefill \\
      &                  & \hrulefill \\
      & Academic Advisor & \hrulefill \\
      & Department Head  & \hrulefill
    \end{tabular*}

    \vspace*{\fill}
  \end{spacing}

  \begin{center}\scriptsize
    Office of Graduate Studies
    $\bullet$ 3141 Chestnut St.
    $\bullet$ Randell Hall 240
    $\bullet$ Philadelphia, PA 19104 \\
    \textbf{Tel.}: 215-895-0366
    $\bullet$ \textbf{Fax}: 215-895-0495
    $\bullet$ \textbf{Email}:
      \href{mailto:graduate@drexel.edu}{graduate@drexel.edu}
    $\bullet$ \textbf{Web}:
      \href{http://www.drexel.edu/provost/graduatestudies/}{%
                   www.drexel.edu/provost/graduatestudies}
  \end{center}
  \endgroup
  \pagebreak
}
\newcommand\drexellogobw{
  \begin{tikzpicture}[y=0.8pt, x=0.8pt,yscale=-1, inner sep=0pt, outer sep=0pt]
  \begin{scope}[cm={{1.25,0.0,0.0,-1.25,(-332.5,550.73629)}},]
    \path[fill=black,nonzero rule] (266.0000,367.4100) -- (338.0000,367.4100) --
      (338.0000,440.5890) -- (266.0000,440.5890) -- (266.0000,367.4100) -- cycle;
    \path[fill=white,nonzero rule] (269.3171,377.0107) -- (334.8469,377.0107) --
      (334.8469,438.7106) -- (269.3171,438.7106) -- (269.3171,377.0107) -- cycle;
    \path[fill=black,nonzero rule] (330.2168,398.2540) .. controls
      (328.9195,397.9603) and (327.1082,397.5687) .. (326.0555,397.4220) --
      (326.0555,396.7855) .. controls (327.6468,396.6388) and (327.6956,396.6388) ..
      (327.6956,395.1942) -- (327.6956,383.2000) .. controls (327.6956,381.8537) and
      (327.5489,381.7070) .. (326.0313,381.5600) -- (326.0313,380.8747) --
      (331.9060,380.8747) -- (331.9060,381.5600) .. controls (330.3147,381.7070) and
      (330.2168,381.8537) .. (330.2168,383.2000) -- (330.2168,398.2540) --
      cycle(319.4750,387.8511) .. controls (319.6711,389.6870) and
      (320.6989,390.8372) .. (321.7273,390.8372) .. controls (322.8042,390.8372) and
      (323.5629,389.5642) .. (323.5629,388.5852) .. controls (323.5629,388.0466) and
      (323.4650,387.8999) .. (323.1225,387.8999) -- (319.4750,387.8511) --
      cycle(325.6436,383.5183) .. controls (324.6889,382.7839) and
      (323.9057,382.4902) .. (323.0734,382.4902) .. controls (321.2375,382.4902) and
      (319.3037,383.7632) .. (319.3528,386.8472) .. controls (322.0207,386.9454) and
      (325.1787,387.1900) .. (325.5215,387.2391) .. controls (325.9865,387.3367) and
      (326.0352,387.3858) .. (326.0352,388.2915) .. controls (326.0352,390.0540) and
      (324.4443,391.7920) .. (322.3881,391.7920) .. controls (319.1570,391.7920) and
      (316.8805,388.7813) .. (316.9296,385.7212) .. controls (316.9784,382.8575) and
      (318.8630,380.5809) .. (322.0698,380.5809) .. controls (322.7551,380.5809) and
      (324.5910,381.0704) .. (325.9865,383.1021) -- (325.6436,383.5183) --
      cycle(312.6069,391.4983) -- (312.6069,390.8130) -- (313.2434,390.7393) ..
      controls (313.7084,390.6659) and (313.5859,390.3968) .. (313.2188,389.7848) ..
      controls (312.8518,389.1729) and (312.4111,388.5118) .. (311.9216,387.8265) --
      (310.5019,389.9561) .. controls (310.1836,390.4210) and (310.2327,390.6659) ..
      (310.6485,390.7147) -- (311.2851,390.8129) -- (311.2851,391.4982) --
      (305.8754,391.4982) -- (305.8754,390.8129) .. controls (307.1972,390.6659) and
      (307.3684,390.5680) .. (308.1762,389.3195) -- (310.4527,385.7948) .. controls
      (309.6938,384.7667) and (308.9839,383.8365) .. (308.4211,383.1021) .. controls
      (307.3930,381.7803) and (307.0259,381.7557) .. (305.6304,381.5599) --
      (305.6304,380.8746) -- (310.2327,380.8746) -- (310.2327,381.5599) --
      (309.5225,381.6824) .. controls (309.1309,381.7557) and (309.0576,381.9027) ..
      (309.4492,382.5635) .. controls (309.9142,383.3470) and (310.4528,384.1547) ..
      (310.9914,384.9379) -- (312.5824,382.5147) .. controls (312.9006,382.0252) and
      (312.8761,381.7069) .. (312.4353,381.6581) -- (311.7258,381.5599) --
      (311.7258,380.8746) -- (317.5271,380.8746) -- (317.5271,381.5599) .. controls
      (316.2053,381.7069) and (315.8867,381.8048) .. (314.9323,383.2491) --
      (312.4599,386.9942) .. controls (313.3168,388.1693) and (314.0021,389.0259) ..
      (314.2715,389.3683) .. controls (315.2997,390.6168) and (315.5934,390.6659) ..
      (317.1355,390.8129) -- (317.1355,391.4982) -- (312.6069,391.4982) --
      cycle(299.3927,387.8511) .. controls (299.5885,389.6870) and
      (300.6166,390.8372) .. (301.6447,390.8372) .. controls (302.7220,390.8372) and
      (303.4806,389.5642) .. (303.4806,388.5852) .. controls (303.4806,388.0466) and
      (303.3827,387.8999) .. (303.0402,387.8999) -- (299.3927,387.8511) --
      cycle(305.5614,383.5183) .. controls (304.6066,382.7839) and
      (303.8234,382.4902) .. (302.9911,382.4902) .. controls (301.1552,382.4902) and
      (299.2215,383.7632) .. (299.2706,386.8472) .. controls (301.9384,386.9454) and
      (305.0961,387.1900) .. (305.4389,387.2391) .. controls (305.9039,387.3367) and
      (305.9530,387.3858) .. (305.9530,388.2915) .. controls (305.9530,390.0540) and
      (304.3617,391.7920) .. (302.3058,391.7920) .. controls (299.0745,391.7920) and
      (296.7982,388.7813) .. (296.8470,385.7212) .. controls (296.8961,382.8575) and
      (298.7808,380.5809) .. (301.9876,380.5809) .. controls (302.6729,380.5809) and
      (304.5087,381.0704) .. (305.9039,383.1021) -- (305.5614,383.5183) --
      cycle(292.7087,391.8408) .. controls (291.4360,391.4492) and
      (289.8205,391.1067) .. (288.6211,390.9109) -- (288.6211,390.3477) .. controls
      (290.1387,390.2007) and (290.1875,390.1519) .. (290.1875,388.6585) --
      (290.1875,383.2000) .. controls (290.1875,381.8537) and (290.0408,381.7070) ..
      (288.5965,381.5600) -- (288.5965,380.8747) -- (294.6428,380.8747) --
      (294.6428,381.5600) .. controls (292.8557,381.7070) and (292.7087,381.8537) ..
      (292.7087,383.2000) -- (292.7087,388.1448) .. controls (293.2476,389.2217) and
      (293.8105,389.5154) .. (294.2266,389.5154) .. controls (294.6182,389.5154) and
      (295.0098,389.3196) .. (295.3526,388.9771) .. controls (295.4993,388.8301) and
      (295.7930,388.7813) .. (296.0625,388.8789) .. controls (296.6253,389.0993) and
      (297.0660,389.8091) .. (297.0660,390.4211) .. controls (297.0660,391.1067) and
      (296.4298,391.8408) .. (295.5484,391.8408) .. controls (294.3487,391.8408) and
      (293.3697,390.2986) .. (292.7823,389.3684) -- (292.7086,389.3684) --
      (292.7086,391.8408) -- cycle(276.3892,394.4356) .. controls
      (276.3892,395.0721) and (276.3892,395.5125) .. (276.5362,395.6350) .. controls
      (276.6829,395.7574) and (277.3194,395.8553) .. (278.1272,395.8553) .. controls
      (282.0438,395.8553) and (284.6874,394.0440) .. (284.6874,388.8055) .. controls
      (284.6874,384.7422) and (282.5821,381.8782) .. (278.5188,381.8782) .. controls
      (276.6341,381.8782) and (276.3892,382.3435) .. (276.3892,384.5952) --
      (276.3892,394.4356) -- cycle(271.6405,396.7855) -- (271.6405,396.0999) ..
      controls (273.4518,395.9532) and (273.6476,395.7574) .. (273.6476,393.1138) --
      (273.6476,384.5464) .. controls (273.6476,381.9028) and (273.4518,381.7070) ..
      (271.4447,381.5599) -- (271.4447,380.8746) -- (277.4419,380.8746) .. controls
      (283.1695,380.8746) and (287.8206,383.5183) .. (287.8206,389.5399) .. controls
      (287.8206,391.6941) and (286.8903,393.5054) .. (285.7643,394.6314) .. controls
      (284.1488,396.1981) and (281.6522,396.7855) .. (278.9104,396.7855) --
      (271.6405,396.7855);
    \path[fill=white,nonzero rule] (277.1649,373.9784) -- (277.1649,371.3099) ..
      controls (277.1649,370.4792) and (277.1239,369.7235) .. (276.0893,369.7235) ..
      controls (275.0546,369.7235) and (275.0137,370.4792) .. (275.0137,371.3099) --
      (275.0137,373.9784) -- (273.9584,373.9784) -- (273.9584,370.9013) .. controls
      (273.9584,369.5942) and (274.8978,368.9613) .. (276.0893,368.9613) .. controls
      (277.2808,368.9613) and (278.2201,369.5942) .. (278.2201,370.9013) --
      (278.2201,373.9784) -- (277.1649,373.9784);
    \path[fill=white,nonzero rule] (285.3943,369.0631) -- (285.3943,373.9784) --
      (284.4072,373.9784) -- (284.4072,370.1253) -- (284.3933,370.1119) --
      (282.5215,373.9785) -- (280.9557,373.9785) -- (280.9557,369.0632) --
      (281.9429,369.0632) -- (281.9429,373.1344) -- (281.9563,373.1482) --
      (283.8966,369.0632) -- (285.3943,369.0632);
    \path[fill=white,nonzero rule] (287.9938,369.0631) -- (289.0489,369.0631) --
      (289.0489,373.9783) -- (287.9938,373.9783) -- (287.9938,369.0631) -- cycle;
    \path[fill=white,nonzero rule] (293.1186,369.0631) -- (294.2692,369.0631) --
      (296.0802,373.9784) -- (295.0383,373.9784) -- (293.7518,370.1047) --
      (293.7380,370.1047) -- (292.4581,373.9784) -- (291.3076,373.9784) --
      (293.1186,369.0631);
    \path[fill=white,nonzero rule] (298.3125,369.0631) -- (301.6824,369.0631) --
      (301.6824,369.8804) -- (299.3678,369.8804) -- (299.3678,371.1940) --
      (301.4647,371.1940) -- (301.4647,372.0109) -- (299.3678,372.0109) --
      (299.3678,373.1615) -- (301.6078,373.1615) -- (301.6078,373.9784) --
      (298.3125,373.9784) -- (298.3125,369.0631);
    \path[fill=white,nonzero rule] (305.3086,373.1615) -- (306.1936,373.1615) ..
      controls (306.6566,373.1545) and (306.9291,372.9710) .. (306.9291,372.5352) ..
      controls (306.9291,372.0997) and (306.6566,371.8682) .. (306.1936,371.8613) --
      (305.3086,371.8613) -- (305.3086,373.1615) -- cycle(305.3086,371.0444) --
      (306.4251,371.0444) .. controls (306.7722,371.0306) and (306.8403,370.6564) ..
      (306.8675,370.3840) .. controls (306.9153,369.9413) and (306.9631,369.4989) ..
      (307.0515,369.0631) -- (308.2158,369.0631) .. controls (308.0181,369.3356) and
      (307.9771,369.9141) .. (307.9297,370.2275) .. controls (307.8413,370.9082) and
      (307.8413,371.4052) .. (307.0309,371.4936) -- (307.0309,371.5074) .. controls
      (307.6369,371.6368) and (308.0521,372.0588) .. (308.0521,372.6986) .. controls
      (308.0521,373.6995) and (307.1877,373.9719) .. (306.3436,373.9785) --
      (304.2533,373.9785) -- (304.2533,369.0632) -- (305.3086,369.0632) --
      (305.3086,371.0444);
    \path[fill=white,nonzero rule] (314.2601,372.5761) .. controls
      (314.2601,373.5633) and (313.5181,374.0806) .. (312.5650,374.0806) .. controls
      (311.5572,374.0806) and (310.5225,373.5836) .. (310.5225,372.4605) .. controls
      (310.5225,371.5889) and (311.4619,371.2759) .. (312.1495,371.1056) .. controls
      (312.5719,370.9969) and (313.2729,370.9560) .. (313.2729,370.3771) .. controls
      (313.2729,369.8529) and (312.7146,369.7235) .. (312.2926,369.7235) .. controls
      (311.7412,369.7235) and (311.4282,370.0912) .. (311.4691,370.6358) --
      (310.3932,370.6358) .. controls (310.3592,369.3968) and (311.1558,368.9613) ..
      (312.2792,368.9613) .. controls (313.3341,368.9613) and (314.3963,369.3834) ..
      (314.3963,370.6017) .. controls (314.3963,371.5889) and (313.2935,371.8001) ..
      (312.5447,371.9906) .. controls (312.1227,372.0928) and (311.6459,372.1540) ..
      (311.6459,372.6851) .. controls (311.6459,373.1140) and (312.0408,373.3184) ..
      (312.4288,373.3184) .. controls (312.9393,373.3184) and (313.2048,373.0731) ..
      (313.2457,372.5761) -- (314.2601,372.5761);
    \path[fill=white,nonzero rule] (316.8870,369.0631) -- (317.9422,369.0631) --
      (317.9422,373.9783) -- (316.8870,373.9783) -- (316.8870,369.0631) -- cycle;
    \path[fill=white,nonzero rule] (320.2146,373.1615) -- (321.6782,373.1615) --
      (321.6782,369.0631) -- (322.7335,369.0631) -- (322.7335,373.1615) --
      (324.1971,373.1615) -- (324.1971,373.9784) -- (320.2146,373.9784) --
      (320.2146,373.1615);
    \path[fill=white,nonzero rule] (327.7961,369.0631) -- (328.8511,369.0631) --
      (328.8511,370.6701) -- (330.5056,373.9784) -- (329.4231,373.9784) --
      (328.3881,371.7251) -- (327.3741,373.9784) -- (326.1417,373.9784) --
      (327.7961,370.6701) -- (327.7961,369.0631);
    \path[fill=black,nonzero rule] (317.2675,431.5469) .. controls
      (316.1860,431.3992) and (315.2214,430.7506) .. (314.6366,429.7477) .. controls
      (314.1108,428.7739) and (313.9058,427.3581) .. (314.6661,426.4142) .. controls
      (315.0459,425.9718) and (315.5138,425.6179) .. (316.0986,425.5884) .. controls
      (317.6768,425.7655) and (318.7000,427.4174) .. (320.2199,427.8005) .. controls
      (321.2140,428.1250) and (322.0325,427.5647) .. (322.7342,427.0042) .. controls
      (323.2604,426.6797) and (323.9912,426.7681) .. (324.4882,427.0926) .. controls
      (322.8511,425.7652) and (321.7401,423.7889) .. (321.5650,421.6357) .. controls
      (321.3308,422.6386) and (320.7169,423.7299) .. (319.7232,424.0839) .. controls
      (318.6126,424.4971) and (317.6480,423.8183) .. (316.8877,423.0810) .. controls
      (316.1864,422.3436) and (315.8940,421.3997) .. (315.5138,420.5146) .. controls
      (316.0400,420.9868) and (316.6834,421.6063) .. (317.4725,421.7536) .. controls
      (318.4665,422.0486) and (319.4020,421.7241) .. (320.1911,421.1344) .. controls
      (320.4540,420.8689) and (320.7759,420.6328) .. (320.8927,420.2199) .. controls
      (319.8990,419.5415) and (319.5772,418.3909) .. (319.6358,417.1814) .. controls
      (319.3142,418.1254) and (318.9636,419.2760) .. (317.8818,419.6889) .. controls
      (317.1801,419.9839) and (316.3032,419.8955) .. (315.7479,419.3054) .. controls
      (315.2800,418.8038) and (315.2509,418.0075) .. (315.3678,417.3291) .. controls
      (315.8062,415.4120) and (317.5602,414.2909) .. (319.2265,413.7304) .. controls
      (320.9514,413.1109) and (322.5299,411.5180) .. (322.7345,409.6304) .. controls
      (322.9978,409.6893) and (323.4362,409.8956) .. (323.6700,409.6006) .. controls
      (323.9329,410.4856) and (324.3422,411.6362) .. (325.3945,411.9309) .. controls
      (326.1545,412.2262) and (326.9439,411.9309) .. (327.5287,411.4001) .. controls
      (328.1426,410.7217) and (328.4350,409.8366) .. (328.2595,408.8927) .. controls
      (328.1717,408.5093) and (327.9962,408.1553) .. (327.7625,407.8308) .. controls
      (327.8502,408.2732) and (327.9088,408.9814) .. (327.6164,409.3943) .. controls
      (327.3823,409.7188) and (327.0316,409.9548) .. (326.6515,409.9548) .. controls
      (326.3594,409.9843) and (326.1548,409.8075) .. (326.0084,409.5714) .. controls
      (325.6869,408.1258) and (327.4995,407.7424) .. (327.5578,406.3856) .. controls
      (327.5873,405.6482) and (327.2949,404.9695) .. (326.6518,404.6453) .. controls
      (325.9505,404.3503) and (325.1902,404.6155) .. (324.6932,405.1466) .. controls
      (324.4303,405.3824) and (324.2256,405.6777) .. (324.1087,405.9724) .. controls
      (324.6346,405.7072) and (325.5995,405.4416) .. (326.1548,405.9433) .. controls
      (326.4180,406.1790) and (326.5346,406.4740) .. (326.5346,406.8280) .. controls
      (326.5932,407.3591) and (326.1839,407.8014) .. (325.8333,408.0964) .. controls
      (325.5114,408.3325) and (325.1607,408.4798) .. (324.7515,408.5388) .. controls
      (324.9856,408.0669) and (324.9564,407.4180) .. (324.6346,407.0051) .. controls
      (324.1087,406.2677) and (323.1733,406.3264) .. (322.3547,406.4151) .. controls
      (321.4779,404.2030) and (319.0516,403.0230) .. (316.8884,402.4330) --
      (315.3098,402.3151) .. controls (316.3039,401.6956) and (317.3562,401.2234) ..
      (318.4086,400.7222) .. controls (318.9639,401.7251) and (319.7530,402.8458) ..
      (320.9517,403.0819) .. controls (321.8285,403.1998) and (322.6471,402.9048) ..
      (323.1441,402.1969) .. controls (323.5534,401.4595) and (323.8163,400.4566) ..
      (323.4657,399.6011) -- (323.0855,398.8932) .. controls (323.2610,399.5421) and
      (323.0563,400.3682) .. (322.5011,400.8695) .. controls (322.2087,401.1056) and
      (321.8285,401.2234) .. (321.4484,401.1645) .. controls (321.0977,401.1056) and
      (320.7471,400.8695) .. (320.6302,400.5156) .. controls (320.2500,398.7753) and
      (322.8226,398.7458) .. (322.5302,396.9761) .. controls (322.4719,396.5039) and
      (322.2673,396.1205) .. (321.8580,395.7961) .. controls (321.2444,395.2948) and
      (320.1331,395.2358) .. (319.4026,395.6192) .. controls (318.9348,395.7961) and
      (318.5255,396.1795) .. (318.1457,396.5039) .. controls (317.5609,396.1795) and
      (316.6546,396.1503) .. (316.1284,396.6221) .. controls (315.3393,397.2711) and
      (315.1930,398.2147) .. (314.9592,399.1292) .. controls (311.7435,400.3977) and
      (308.7325,402.2561) .. (306.2186,404.9698) .. controls (304.4354,406.8872) and
      (303.6460,409.5125) .. (304.0553,412.1968) .. controls (304.4646,414.6744) and
      (304.2305,417.5357) .. (302.0966,419.0108) .. controls (301.1026,419.5415) and
      (299.8161,419.8071) .. (298.7055,419.3647) .. controls (297.5945,418.8929) and
      (296.8346,417.6539) .. (296.8054,416.4150) .. controls (296.8640,414.2026) and
      (298.0919,412.3444) .. (299.0860,410.4565) .. controls (300.0214,408.2146) and
      (299.6121,405.4122) .. (297.8581,403.7607) .. controls (296.4842,402.0793) and
      (294.5259,401.5780) .. (293.0057,400.1914) .. controls (292.8010,399.9848) and
      (292.7136,399.6606) .. (292.8305,399.3951) .. controls (293.3275,398.7462) and
      (294.2921,398.7462) .. (295.1107,398.8051) .. controls (296.8644,399.1296) and
      (298.1796,400.4570) .. (299.8459,400.9288) .. controls (300.8986,401.0764) and
      (301.9215,400.7225) .. (302.4771,399.8080) .. controls (302.6817,399.4246) and
      (302.8569,398.9230) .. (302.7109,398.4511) .. controls (302.5648,397.9790) and
      (302.2138,397.5367) .. (301.8046,397.3300) .. controls (301.5416,397.2122) and
      (301.1615,397.2416) .. (300.8691,397.2711) .. controls (301.2201,397.3893) and
      (301.6585,397.6546) .. (301.7754,398.1264) .. controls (301.8631,398.5101) and
      (301.7463,398.9230) .. (301.4830,399.2180) .. controls (301.1615,399.5130) and
      (300.8108,399.6607) .. (300.3724,399.6607) .. controls (300.6353,399.3359) and
      (300.8691,398.8935) .. (300.8108,398.3919) .. controls (300.6939,397.6251) and
      (300.1678,396.8877) .. (299.4075,396.6811) .. controls (299.0277,396.5633) and
      (298.6475,396.7106) .. (298.3260,396.9172) .. controls (298.0339,397.1533) and
      (297.9167,397.4188) .. (297.7707,397.7138) .. controls (297.9753,397.5072) and
      (298.2383,397.3599) .. (298.5306,397.3893) .. controls (298.9399,397.4482) and
      (299.2323,397.6840) .. (299.3783,398.0678) .. controls (299.4661,398.3330) and
      (299.4661,398.6873) .. (299.3197,398.9230) .. controls (299.1446,399.1885) and
      (298.8522,399.3657) .. (298.5015,399.2769) .. controls (297.3906,398.9230) and
      (297.1568,397.3599) .. (296.0167,397.0056) .. controls (294.5551,396.8877) and
      (293.0057,397.0649) .. (291.4858,396.9761) -- (286.8671,396.8582) .. controls
      (286.6042,396.9466) and (286.2824,397.0056) .. (286.1655,397.3009) .. controls
      (285.6393,398.1856) and (286.9549,399.1885) .. (285.8439,399.8673) .. controls
      (283.0376,401.7843) and (279.9097,403.7017) .. (278.0679,406.8283) .. controls
      (276.4017,409.6307) and (274.9692,413.8490) .. (277.0735,416.9166) .. controls
      (278.1845,418.5095) and (280.0263,419.4535) .. (282.0432,419.0995) .. controls
      (283.6508,418.8929) and (284.9956,417.5656) .. (285.4049,416.0316) --
      (285.4927,415.5005) .. controls (284.8787,416.5921) and (283.8850,417.6834) ..
      (282.6277,418.0963) .. controls (282.7449,417.7718) and (282.6863,417.3000) ..
      (282.6280,416.9461) .. controls (282.3942,417.4771) and (281.7509,417.9490) ..
      (281.1664,418.1556) .. controls (281.4293,417.6834) and (281.7220,417.1229) ..
      (281.6340,416.5037) .. controls (281.2247,416.9755) and (280.6111,417.4474) ..
      (279.9386,417.2705) .. controls (280.4647,416.8282) and (280.9326,416.3560) ..
      (281.1373,415.6776) .. controls (280.6697,415.9726) and (279.9680,416.2676) ..
      (279.3246,416.0021) .. controls (279.8803,415.6482) and (280.8743,415.3531) ..
      (280.8743,414.4386) .. controls (280.5819,414.6453) and (280.1727,414.7337) ..
      (279.8217,414.6453) -- (279.3832,414.4386) .. controls (279.8217,414.2618) and
      (280.4356,414.1145) .. (280.7571,413.6424) -- (281.0204,413.1705) .. controls
      (280.4064,413.2294) and (279.7634,413.1407) .. (279.3246,412.6689) .. controls
      (279.9972,412.5510) and (280.6988,412.4626) .. (281.1373,411.8432) .. controls
      (280.5525,411.6955) and (279.9386,411.3710) .. (279.7339,410.7221) .. controls
      (280.2896,411.0171) and (281.1373,411.0171) .. (281.6634,410.5747) .. controls
      (281.0204,410.2208) and (280.3478,409.5423) .. (280.5233,408.6868) .. controls
      (281.0790,409.1291) and (281.8681,409.5129) .. (282.6283,409.1586) .. controls
      (281.8098,408.8047) and (281.2836,407.9789) .. (281.2541,407.1528) --
      (281.2836,406.9171) .. controls (281.8681,407.5955) and (282.6284,408.0378) ..
      (283.5344,407.8610) .. controls (282.7453,407.4773) and (282.3943,406.6810) ..
      (282.4820,405.7959) .. controls (282.6284,405.8846) and (282.7453,406.0910) ..
      (282.9208,406.2092) .. controls (283.4761,406.5631) and (284.0314,406.9171) ..
      (284.6745,406.9465) .. controls (284.2360,406.3565) and (283.6221,405.5893) ..
      (283.8854,404.7341) .. controls (284.2946,405.5013) and (285.0546,406.3270) ..
      (285.9314,406.4154) .. controls (285.4930,405.8254) and (285.3470,405.0881) ..
      (285.3470,404.3212) .. controls (285.9609,405.1765) and (286.8669,406.1794) ..
      (287.8901,406.5631) .. controls (287.5391,405.9141) and (287.2176,404.8225) ..
      (287.5977,404.0262) .. controls (287.8901,404.9997) and (288.5040,406.0026) ..
      (289.2348,406.6512) .. controls (289.0885,405.8254) and (289.3517,405.0586) ..
      (289.9948,404.4980) -- (290.0534,404.5569) .. controls (290.0239,405.6191) and
      (290.4332,406.5333) .. (290.9594,407.3299) .. controls (290.8425,406.6220) and
      (291.2517,405.9730) .. (291.8657,405.6188) -- (292.1289,405.5009) .. controls
      (291.8365,406.2386) and (291.6319,407.0938) .. (291.7779,408.0083) .. controls
      (292.3041,407.4478) and (293.0644,406.7693) .. (293.9117,406.8872) .. controls
      (292.6551,408.0083) and (291.3978,409.2473) .. (290.8716,410.8104) .. controls
      (291.3686,410.2797) and (292.1577,409.9254) .. (293.0054,409.9847) .. controls
      (291.4272,411.1054) and (289.9948,413.0523) .. (289.8484,415.0876) .. controls
      (290.1994,414.2618) and (290.9885,413.6125) .. (291.8071,413.3178) .. controls
      (290.6961,414.9697) and (289.5269,416.8868) .. (290.1405,419.1286) .. controls
      (290.2868,418.0668) and (290.9008,416.8868) .. (292.0117,416.5626) .. controls
      (291.3978,417.7129) and (290.5792,418.8929) .. (290.7544,420.3676) .. controls
      (290.8127,421.2821) and (291.1051,422.1671) .. (291.6312,422.9045) .. controls
      (291.2514,422.0784) and (291.1928,420.7808) .. (291.9528,420.0137) --
      (292.0114,419.9548) .. controls (291.7776,422.2556) and (292.6544,424.5269) ..
      (294.6422,425.5888) -- (295.4022,426.0016) .. controls (294.7883,425.2050) and
      (294.3793,424.3498) .. (294.3793,423.3171) .. controls (295.2558,425.2050) and
      (297.0976,427.0635) .. (299.4364,426.9456) .. controls (299.7870,426.9751) and
      (300.1086,426.9158) .. (300.4301,426.8569) .. controls (299.4655,426.4146) and
      (298.2668,425.6769) .. (298.1499,424.4677) .. controls (299.7284,425.9129) and
      (301.9503,426.7096) .. (304.1133,425.9129) .. controls (304.6103,425.7063) and
      (305.1656,425.4411) .. (305.4872,425.0279) .. controls (304.7272,425.4411) and
      (303.8504,425.1166) .. (303.2070,424.7034) .. controls (302.9149,424.4972) and
      (302.5056,424.2021) .. (302.3888,423.8482) .. controls (303.8795,424.4088) and
      (306.1597,424.7922) .. (307.3289,423.2877) -- (308.0598,422.1374) .. controls
      (307.2707,422.6685) and (306.3352,423.1108) .. (305.3120,422.9046) .. controls
      (305.1365,422.8453) and (304.9610,422.7569) .. (304.7858,422.6092) .. controls
      (306.4226,422.5503) and (308.0306,421.7537) .. (308.7028,420.2200) --
      (308.9075,419.3055) .. controls (308.4982,420.1021) and (307.6505,420.8984) ..
      (306.6859,420.9279) .. controls (307.2412,420.3382) and (308.0892,419.7482) ..
      (308.3521,418.9221) .. controls (308.9078,417.6831) and (309.0538,416.1789) ..
      (310.3985,415.4121) .. controls (310.9247,415.1466) and (311.4800,414.9694) ..
      (312.0648,414.8810) .. controls (310.0479,415.7068) and (309.3171,418.1258) ..
      (309.1707,420.2495) .. controls (309.6677,419.6303) and (310.3108,419.0694) ..
      (311.0125,418.7748) .. controls (310.6615,419.2171) and (310.3108,419.5121) ..
      (309.9307,419.9839) .. controls (308.7614,421.4001) and (308.0598,423.2582) ..
      (308.4982,425.1461) .. controls (308.8197,426.3553) and (309.6383,427.3582) ..
      (310.4274,428.3611) .. controls (309.7846,427.1224) and (309.6674,425.3233) ..
      (310.4569,424.1137) .. controls (310.8367,423.5237) and (311.3632,423.0221) ..
      (311.8893,422.6387) .. controls (310.8661,423.9955) and (310.3982,426.0013) ..
      (311.0122,427.7419) .. controls (311.8890,430.1312) and (314.3444,431.3993) ..
      (316.7123,431.5764) -- (317.2676,431.5469);
    \path[fill=white,nonzero rule] (314.4906,424.9100) .. controls
      (314.8707,424.6150) and (315.4260,424.4378) .. (315.9231,424.6444) .. controls
      (316.0109,424.6739) and (316.0986,424.7328) .. (316.2155,424.7623) .. controls
      (315.7770,424.2905) and (315.3091,423.3171) .. (314.4906,423.5237) .. controls
      (313.7892,424.0544) and (314.0522,425.1461) .. (313.9936,425.9424) .. controls
      (314.0231,425.5295) and (314.1982,425.2050) .. (314.4906,424.9100);
    \path[fill=white,nonzero rule] (312.1524,410.9578) .. controls
      (312.7372,411.0167) and (313.2634,411.4001) .. (313.5849,411.8723) .. controls
      (313.9356,410.8101) and (314.4621,409.1880) .. (313.5849,408.1851) .. controls
      (313.3220,407.9196) and (313.0005,407.8014) .. (312.6203,407.8014) .. controls
      (311.1587,407.8901) and (310.5157,409.4238) .. (310.1060,410.6627) .. controls
      (309.8140,411.5183) and (309.8140,412.4623) .. (309.6968,413.4062) .. controls
      (310.1355,412.3735) and (310.8663,410.9283) .. (312.1524,410.9578);
    \path[fill=white,nonzero rule] (320.8934,398.4803) .. controls
      (321.1563,398.2147) and (321.3023,397.9200) .. (321.2440,397.5363) .. controls
      (321.2440,397.2122) and (320.9517,396.8874) .. (320.6887,396.7695) .. controls
      (320.0748,396.5039) and (319.3440,396.7106) .. (318.8178,397.0056) .. controls
      (319.3145,397.5068) and (319.6072,398.0969) .. (319.6947,398.7458) .. controls
      (320.1331,398.8047) and (320.5424,398.7163) .. (320.8934,398.4803);
    \path[fill=white,nonzero rule] (322.0034,426.5913) .. controls
      (322.0616,426.2668) and (321.8865,426.0013) .. (321.6232,425.8834) .. controls
      (321.1848,425.7652) and (320.6000,425.7652) .. (320.2785,426.1195) .. controls
      (320.1324,426.3258) and (320.0447,426.6208) .. (320.2199,426.8274) .. controls
      (320.6586,427.3581) and (321.6818,427.2403) .. (322.0034,426.5913);
    \path[fill=white,nonzero rule] (317.0930,398.3624) .. controls
      (317.0639,398.0968) and (316.8592,397.8611) .. (316.5963,397.8018) .. controls
      (316.2453,397.7723) and (316.1575,398.0968) .. (316.0701,398.3624) --
      (316.0406,398.7753) -- (317.0929,398.3624);
    \path[fill=white,nonzero rule] (323.3484,407.8309) .. controls
      (323.3193,407.3590) and (322.9977,407.1524) .. (322.5885,407.0051) .. controls
      (322.7345,407.4474) and (322.7640,407.9785) .. (322.7057,408.4504) .. controls
      (322.9686,408.3325) and (323.2315,408.1259) .. (323.3484,407.8309);
  \end{scope}
  \end{tikzpicture}
}
\DeclareOptionX{subfig}{\@DUT@subfigopttrue}
\DeclareOptionX{finalspace}{
  \setlength\overfullrule{0pt}
  \def\@DUT@toc@sep{1} % content page separation (# blanklines between entries)
  \def\@ssp{1} % single space
  \def\@dsp{2} % double space
  \def\@tsp{3} % triple space
}
\DeclareOptionX{draftspace}{
  \setlength\overfullrule{5pt}
  \def\DUT@toc@sep{0} % content page separation (# blanklines between entries)
  \def\@ssp{1} % single space
  \def\@dsp{1} % double space
  \def\@tsp{2} % triple space
}
\DeclareOptionX{pagebreak}{
  \@DUT@pagebreaktrue
  \PassOptionsToClass{openright}{book}
}
\DeclareOptionX{nopagebreak}{
  \@DUT@pagebreakfalse
  \PassOptionsToClass{openany}{book}
}
\DeclareOptionX{dottedpart}{\@dottedparttrue}
\DeclareOptionX{dottedchapter}{\@dottedchaptertrue}
\DeclareOptionX{boldpart}{\@boldparttrue}
\DeclareOptionX{boldchapter}{\@boldchaptertrue}
\DeclareOptionX{dottedtoc}{
  \setkeys{drexel-thesis.cls}{dottedpart}
  \setkeys{drexel-thesis.cls}{dottedchapter}
}
\DeclareOptionX{boldtoc}{
  \setkeys{drexel-thesis.cls}{boldpart}
  \setkeys{drexel-thesis.cls}{boldchapter}
}
\DeclareOptionX{indenttoc}{\@indenttoctrue}
\DeclareOptionX{blackref}{\@blackreftrue}
\DeclareOptionX{draftwatermark}{%
  \@draftwatermarktrue
  \@xdraftwatermarkfalse}
\DeclareOptionX{xdraftwatermark}{%
  \@draftwatermarkfalse
  \@xdraftwatermarktrue}
 \DeclareOptionX{nodraftwatermark}{%
  \@draftwatermarkfalse
  \@xdraftwatermarkfalse}
\DeclareOptionX{indentfirst}{\@indentfirsttrue}
\DeclareOptionX{oneside}{\PassOptionsToClass{oneside}{book}}
\DeclareOptionX{twoside}{\PassOptionsToClass{twoside}{book}}
\DeclareOptionX{final}{
  \@finaltrue
  \setkeys{drexel-thesis.cls}{oneside}
  \setkeys{drexel-thesis.cls}{finalspace}
  \setkeys{drexel-thesis.cls}{pagebreak}
  \setkeys{drexel-thesis.cls}{dottedtoc}
}
\DeclareOptionX{draft}{
  \@finalfalse
  \setkeys{drexel-thesis.cls}{twoside}
  \setkeys{drexel-thesis.cls}{draftspace}
  \setkeys{drexel-thesis.cls}{nopagebreak}
  \setkeys{drexel-thesis.cls}{dottedtoc}
  \setkeys{drexel-thesis.cls}{xdraftwatermark}
}
\DeclareOptionX{daring}{
  \@daringtrue
}
\DeclareOptionX{approvalform}{
  \@approvalformtrue
}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{book}}
\ExecuteOptionsX{final}
\ProcessOptionsX\relax
\LoadClass{book}
\RequirePackage{setspace}
\RequirePackage{calc}
\RequirePackage[final]{graphicx}
\if@draftwatermark
  \RequirePackage[draft,allpages,mark={DRAFT \today},
                  fontsize=2cm,grayness=0.9]{draftmark}
\fi
\if@xdraftwatermark
  \RequirePackage{eso-pic}
  \RequirePackage{xcolor}
  \definecolor{watermark}{rgb}{0.9,0.9,0.9}
  \newcommand{\watermarkfont}{%
    \color{watermark}}%\fontfamily{phv}\selectfont\sffamily}
  \newcommand{\watermark}{%
    \rule{4.25in}{0pt}\raisebox{5.5in}{%
      \makebox[0pt]{%
\rotatebox[origin=c]{45}{%
          \resizebox{!}{1.5in}{%
            {\watermarkfont DRAFT}%
    }}}}
    \raisebox{4.2in}{%
      \makebox[0pt]{%
\rotatebox[origin=c]{45}{%
          \resizebox{!}{.6in}{%
            {\watermarkfont \qquad\today}%
    }}}}}
  \AddToShipoutPicture{\watermark{}}
\fi
\if@indentfirst
  \RequirePackage{indentfirst}
\fi
\RequirePackage[letterpaper,margin=1in,bindingoffset=0.5in]{geometry}
\if@DUT@subfigopt
  \RequirePackage[subfigure]{tocloft}
\else
  \RequirePackage{tocloft}
\fi
\RequirePackage[margin=10pt,labelfont=bf,labelsep=colon]{caption}
\RequirePackage{floatrow}
\floatsetup[table]{style=plaintop}
\floatsetup{captionskip=10pt}
\floatsetup[table]{captionskip=10pt}
\if@DUT@subfigopt
  \RequirePackage{fr-subfig}
\fi
\if@DUT@subfigopt
  \RequirePackage{subfig}
\fi
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.4pt}
\fancyfoot[RE,LO]{\scshape\leftmark}
\fancyfoot[LE,RO]{\scshape\rightmark}
\fancyhead[LE,RO]{\thepage}
\fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\footrulewidth}{0pt}
  \fancyhead[LE,RO]{\thepage}
}
\fancypagestyle{empty}{
  \fancyhf{}
  \renewcommand{\footrulewidth}{0pt}
}
\RequirePackage{ifpdf}
\if@approvalform\RequirePackage{tikz}\fi
\renewcommand{\title}[1]{
  \gdef\@DUT@title{#1}
  \ifpdf \hypersetup{pdftitle={\@DUT@title}} \fi
}
\let\DUTtitle\title
\def\@DUT@title{\@latex@error{No \noexpand\title given}\@ehc}
\renewcommand{\author}[1]{
  \gdef\@DUT@author{#1}
  \ifpdf \hypersetup{pdfauthor={\protect\@DUT@author}} \fi
}
\let\DUTauthor\author
\def\@DUT@author{\@latex@error{No \noexpand\author given}\@ehc}
\def\DUTmonth#1{\gdef\@DUT@month{#1}}
\def\@DUT@month{\@latex@error{No \noexpand\DUTmonth given}\@ehc}
\def\DUTyear#1{\gdef\@DUT@year{#1}}
\def\@DUT@year{\@latex@error{No \noexpand\DUTyear given}\@ehc}
\def\degree#1{\gdef\@DUT@degree{#1}
  \ifpdf \hypersetup{pdfsubject={\@DUT@degree}} \fi}
\let\DUTdegree\degree
\def\@DUT@degree{\@latex@error{No \noexpand\degree given}\@ehc}
\def\copyrighttext#1{\gdef\@DUT@copyrighttext{#1}}
\let\DUTcopyrighttext\copyrighttext
\def\@DUT@copyrighttext{All Rights Reserved.}
\newcounter{@DUT@advisors}
\setcounter{@DUT@advisors}{0}
\newcommand\advisor[1]{%
  \ifx
    \empty{#1}
  \else
    \stepcounter{@DUT@advisors}
    \expandafter\gdef\csname @DUT@advisor@\alph{@DUT@advisors}\endcsname{#1}
  \fi}
\newcommand\@DUT@advisor{%
  \ifnum\c@@DUT@advisors=0%
    \@latex@error{No \noexpand\advisor given}\@ehc%
  \else%
    \begingroup%
      \count@\@ne
      \csname @DUT@advisor@\@alph\count@\endcsname\relax%
      \loop\ifnum\count@<\c@@DUT@advisors%
        \advance\count@\@ne
        \ifnum\count@=\c@@DUT@advisors%
          \ifnum\c@@DUT@advisors=2%
            {\ and\ }%
          \else%
            {, and\ }%
          \fi%
        \else%
          {,\ }%
        \fi%
        \csname @DUT@advisor@\@alph\count@\endcsname\relax%
      \repeat%
    \endgroup%
  \fi}
\newlength\@DUT@baselineskip
\setlength\@DUT@baselineskip\baselineskip
\newcommand{\set@lines@length}[2]{%
  \setlength{#1}{\@DUT@baselineskip * {#2}}}
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      \setstretch{\@ssp}%
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M #8\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
\def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      \setstretch{\@ssp}%
      #4{%
        \@hangfrom{\hskip #1}%
          \interlinepenalty \@M #5\@@par}%
    \endgroup
  \else
    \def\@svsechd{#4{\hskip #1\relax #5}}%
  \fi
  \@xsect{#3}}
\newcommand\@DUT@clearpage{%
  \if@DUT@pagebreak \clearpage \else \blanklinesp{4} \fi}
\newcommand\@DUT@cleardoublepage{%
  \if@DUT@pagebreak \cleardoublepage \else \blanklinesp{4} \fi}
\newcommand\@DUT@newpage{%
  \if@DUT@pagebreak \newpage \else \blanklinesp{4} \fi}
\newcommand\@DUT@blankpage{%
  \if@DUT@pagebreak
    \@DUT@clearpage
    \thispagestyle{empty}
    \hphantom{0}
    \@DUT@clearpage
  \fi
}
\newlength\@DUT@blanklines@length
\newcommand{\@blanklines@setup}[1]{%
  \set@lines@length{\@DUT@blanklines@length}{#1}%
  %\typeout{BLANKLINES -- #1}%
  %\showthe\@DUT@blanklines@length
}
\newcommand{\blanklines}{\@ifstar\@sblanklines\@blanklines}
\newcommand{\@blanklines}[1]{%
  \@blanklines@setup{#1}%
  \vspace{\@DUT@blanklines@length}}
\newcommand{\@sblanklines}[1]{%
  \@blanklines@setup{#1}%
  \vspace*{\@DUT@blanklines@length}}
\newcommand{\blanklinesp}{\@ifstar\@sblanklines\@blanklines}
\newcommand{\@blanklinesp}[1]{%
  \@blanklines@setup{#1}%
  \vspace{\@DUT@blanklines@length}\par}
\newcommand{\@sblanklinesp}[1]{%
  \@blanklines@setup{#1}%
  \vspace*{\@DUT@blanklines@length}\par}
\RequirePackage[final]{hyperref}
\hypersetup{colorlinks}
\if@blackref
  \hypersetup{linkcolor=black}
  \hypersetup{anchorcolor=black}
  \hypersetup{citecolor=black}
  \hypersetup{filecolor=black}
  \hypersetup{menucolor=black}
  \hypersetup{runcolor=black}
  \hypersetup{urlcolor=black}
\fi
\RequirePackage[all]{hypcap}
\set@lines@length{\floatsep}{\@ssp}
\set@lines@length{\textfloatsep}{\@tsp}
\newcommand\@DUT@maketitle{
  \begin{@DUT@titlepage}%
    \ifpdf
      \pdfbookmark[-1]{Front Matter}{Front Matter}
      \pdfbookmark[0]{Title Page}{Title Page}
    \fi
    \if@DUT@pagebreak \vspace*{\fill} \fi
    \begin{center}%
      {\setstretch{\@tsp} \bfseries \@DUT@title \par}%
      \blanklines{\@tsp}%
      \setstretch{\@dsp}%
      A Thesis\\
      Submitted to the Faculty\\
      of\\
      Drexel University\\
      by\\
      \@DUT@author\\
      in partial fulfillment of the\\
      requirements for the degree\\
      of\\
      \@DUT@degree\\
      \@DUT@month\ \@DUT@year
    \end{center}\par
    \if@DUT@pagebreak \vspace*{\fill}
    \centering
    \mbox{\smash{\includegraphics[width=4cm]{drexel-logo}}}
    \fi
  \end{@DUT@titlepage}%
  \setcounter{footnote}{0}%
  \global\let\maketitle\relax
  \global\let\and\relax
}
\newcommand\@DUT@makecopyright{%
  \@DUT@clearpage
  \ifpdf \pdfbookmark[0]{Copyright Page}{Copyright Page} \fi
  \if@DUT@pagebreak \vspace*{\fill} \fi
  \begin{center}
    \copyright~Copyright \@DUT@year\\
    \@DUT@author.~All Rights Reserved.  \@DUT@copyrighttext
  \end{center}
  \if@DUT@pagebreak \vspace*{\fill} \fi
  \thispagestyle{empty}
}
\newcommand\copyrighttextCCBYSA{
  \begin{quote}
    This work is licensed under the terms of the Creative Commons
    Attribution-ShareAlike 4.0 International license.  The license is
    available at \\
    \url{http://creativecommons.org/licenses/by-sa/4.0/}.
  \end{quote}
}
\let\DUTcopyrighttextCCBYSA\copyrighttextCCBYSA
\renewcommand\chaptermark[1]{%
  \markboth {%
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \@chapapp\ \thechapter: \ %
      \fi
    \fi
    #1}{}}
\newcommand\schaptermark[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{%
  \markright {%
    \ifnum \c@secnumdepth >\z@
      \thesection \ %
    \fi
    #1}}
\renewcommand\mainmatter{%
  \@DUT@cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}}
\renewcommand\part{%
  \if@openright
    \@DUT@cleardoublepage
  \else
    \@DUT@clearpage
  \fi
  \thispagestyle{plain}%
  \@tempswafalse
  \if@DUT@pagebreak \null\vfil \fi
  \secdef\@part\@spart}
\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      \addcontentsline{toc}{part}%
        {\protect\numberline{\thepart}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       \large\bfseries \partname\nobreakspace\thepart
       \par
       \vskip 20\p@
     \fi
     \large \bfseries #2\par}%
    \@endpart}
\def\@spart#1{%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \large \bfseries #1\par}%
    \@endpart}
\def\@endpart{
  \if@DUT@pagebreak \vfil\newpage \fi
  \if@twoside
    \if@openright
      \null
      \thispagestyle{empty}%
      \newpage
    \fi
  \fi}
\renewcommand\chapter{%
  \if@openright\@DUT@cleardoublepage\else\@DUT@clearpage\fi
  \thispagestyle{plain}%
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter}
\newcommand\listed@schapter[1]{%
  \if@openright\@DUT@cleardoublepage\else\@DUT@clearpage\fi
  \thispagestyle{plain}%
  \global\@topnum\z@
  \phantomsection
  \addcontentsline{toc}{chapter}{#1}
  \@afterindentfalse
  \@schapter{#1}}
\def\@chapter[#1]#2{
  \let\@DUT@label=\label%
  \renewcommand{\label}[1]{}%
  \typeout{\@chapapp\space\thechapter. #1}%
  \let\label=\@DUT@label%
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
    \else
      \addcontentsline{toc}{chapter}{#1}%
    \fi
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \@makechapterhead{#2}%
  \@afterheading}
\def\@makechapterhead#1{%
  \blanklines*{-1}% HACK!
  {\parindent \z@ \raggedright \normalfont
    \setstretch{\@ssp}%
    \interlinepenalty\@M
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \center \large \bfseries \@chapapp{} \thechapter: #1\par\nobreak
      \else
        \center \large \bfseries #1\par\nobreak
      \fi
    \else
      \center \large \bfseries #1\par\nobreak
    \fi
    \blanklines{4}
  }
}
\def\@schapter#1{
  \typeout{\@chapapp\space #1}%
  \schaptermark{#1}%
  \@makeschapterhead{#1}%
  \@afterheading}
\def\@makeschapterhead#1{%
  \blanklines*{-1}% HACK!
  {\parindent \z@ \raggedright \normalfont
    \setstretch{\@ssp}%
    \interlinepenalty\@M
    \center \large \bfseries  #1\par\nobreak
    \blanklines{4}%
  }
}
\renewcommand\section{%
  \@startsection {section}{1}{\z@}%
    {-3.5ex \@plus -1ex \@minus -.2ex}%
    {2.3ex \@plus.2ex}%
    {\normalfont\large\bfseries}}
\newenvironment{preamble}{%
  \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}
  \if@approvalform
    \ifpdf
      \pdfbookmark[-1]{Approval Form}{Approval Form}
    \fi
    \DUT@makeapprovalform
  \fi
  \@DUT@maketitle
  \@DUT@makecopyright
}{%
  \@DUT@blankpage
}
\let\DUTpreamble\preamble
\let\endDUTpreamble\endpreamble
\newenvironment{dedications}{%
  \@DUT@clearpage
  \ifpdf
    \phantomsection
    \pdfbookmark[0]{\DUTdedicationsname}{\DUTdedicationsname}
  \fi
  \chapter*{\DUTdedicationsname}
  \setstretch{\@dsp}%
}{%
  \par\setstretch{\@ssp}%
}
\let\DUTdedications\dedications
\let\endDUTdedications\enddedications
\newenvironment{acknowledgments}{%
  \@DUT@clearpage
  \ifpdf
    \phantomsection
    \pdfbookmark[0]{\DUTacknowledgmentsname}{\DUTacknowledgmentsname}
  \fi
  \chapter*{\acknowledgmentsname}
  \setstretch{\@dsp}%
}{%
  \par\setstretch{\@ssp}%
}
\let\DUTacknowledgments\acknowledgments
\let\endDUTacknowledgments\endacknowledgments
\newenvironment{abstract}{%
  \listed@schapter{\abstractname}%
  \blanklines{-4}%
    \begin{center}
      \setstretch{\@ssp}%
      \@DUT@title\\
      \@DUT@author\\
      \ifdaring{%
        \ifnum\c@@DUT@advisors=\@ne%
        Advisor:
        \else%
        Advisors:
        \fi}{}
      \@DUT@advisor\\
    \end{center}
  \blanklines{4}%
  \setstretch{\@dsp}%
  \@nobreaktrue
  \@afterindentfalse
  \@afterheading
}{%
  \par\setstretch{\@ssp}%
}
\let\DUTabstract\abstract
\let\endDUTabstract\endabstract
\newenvironment{thesis}{%
  \mainmatter
  \setstretch{\@dsp}%
}{%
  \setstretch{\@ssp}%
  \@DUT@clearpage
  \ifpdf
    \phantomsection
    \pdfbookmark[-1]{Back Matter}{Back Matter}
  \fi
}
\let\DUTthesis\thesis
\let\endDUTthesis\endthesis
\newenvironment{vita}{%
  \listed@schapter{\vitaname}
  \setstretch{\@dsp}%
}{%
  \par\setstretch{\@ssp}%
}
\let\DUTvita\vita
\let\endDUTvita\endvita
\renewenvironment{titlepage}%
  {\thispagestyle{empty}\setcounter{page}\z@}%
  {\@DUT@newpage}
\let\@DUT@titlepage\titlepage
\let\end@DUT@titlepage\endtitlepage
\let\@DUT@appendix\appendix
\renewcommand\appendix{%
  \@DUT@appendix%
  \addtocontents{toc}{%
    \protect\cftsetindents{chapter}{0pt}{6.5em}
    \protect\renewcommand{\protect\cftchappresnum}{\protect\appendixname~}
    \protect\renewcommand{\protect\cftchapaftersnum}{:}}
  \setstretch{\@dsp}%
}
\let\DUTappendix\appendix
\renewcommand\cfttoctitlefont{%
  \@DUT@clearpage
  \ifpdf
    \phantomsection
    \pdfbookmark[0]{\contentsname}{\contentsname}
  \fi
  \chapter*}
\setlength\cftaftertoctitleskip{0pt}
\newlength\l@DUT@toc@sep
\set@lines@length{\l@DUT@toc@sep}{\@DUT@toc@sep}
\newcommand{\DUT@toc@high@font}{\normalsize\scshape}
\newcommand{\DUT@toc@low@font}{\normalfont}
\newcommand{\DUT@toc@page@font}{\normalfont}
\setlength\cftbeforepartskip{\l@DUT@toc@sep}
\cftsetindents{part}{0pt}{3em}
\if@boldpart   \renewcommand{\cftpartfont}{\bfseries\DUT@toc@high@font}
\else          \renewcommand{\cftpartfont}{\DUT@toc@high@font}
\renewcommand{\cftpartleader}{\cftdotfill{\cftpartdotsep}}
\if@dottedpart \renewcommand{\cftpartdotsep}{\cftdotsep}
\else          \renewcommand{\cftpartdotsep}{\cftnodots} \fi
\renewcommand{\cftpartpagefont}{\DUT@toc@page@font}
\setlength\cftbeforechapskip{\l@DUT@toc@sep}
\cftsetindents{chapter}{0pt}{1.5em}
\renewcommand{\cftchapaftersnum}{.}
\if@boldchapter   \renewcommand{\cftchapfont}{\bfseries\DUT@toc@high@font}
\else             \renewcommand{\cftchapfont}{\DUT@toc@high@font} \fi
\renewcommand{\cftchapleader}{\cftdotfill{\cftchapdotsep}}
\if@dottedchapter \renewcommand{\cftchapdotsep}{\cftdotsep}
\else             \renewcommand{\cftchapdotsep}{\cftnodots} \fi
\renewcommand{\cftchappagefont}{\DUT@toc@page@font}
\setlength\cftbeforesecskip{\l@DUT@toc@sep}
\cftsetindents{section}{0pt}{3em}
\renewcommand{\cftsecfont}{\DUT@toc@low@font}
\renewcommand{\cftsecpagefont}{\DUT@toc@page@font}
\setlength\cftbeforesubsecskip{\l@DUT@toc@sep}
\cftsetindents{subsection}{0pt}{4.5em}
\renewcommand{\cftsubsecfont}{\DUT@toc@low@font}
\renewcommand{\cftsubsecpagefont}{\DUT@toc@page@font}
\setlength\cftbeforesubsubsecskip{\l@DUT@toc@sep}
\cftsetindents{subsubsection}{0pt}{6em}
\renewcommand{\cftsubsubsecfont}{\DUT@toc@low@font}
\renewcommand{\cftsubsubsecpagefont}{\DUT@toc@page@font}
\if@indenttoc
  \cftsetindents{chapter}{0pt}{1.5em}
  \cftsetindents{section}{1.5em}{2.3em}
  \cftsetindents{subsection}{3.8em}{3.2em}
  \cftsetindents{subsubsection}{7.0em}{4.1em}
\fi
\renewcommand\cftloftitlefont{\listed@schapter}
\setlength\cftafterloftitleskip{-12pt}
\setlength{\cftbeforefigskip}{\l@DUT@toc@sep}
\setlength{\cftfigindent}{0pt}
\renewcommand{\cftfigfont}{\DUT@toc@low@font}
\renewcommand{\cftfigpagefont}{\DUT@toc@page@font}
\renewcommand\cftlottitlefont{\listed@schapter}
\setlength\cftafterlottitleskip{-12pt}
\setlength{\cfttabindent}{0pt}
\setlength{\cftbeforetabskip}{\l@DUT@toc@sep}
\renewcommand{\cfttabfont}{\DUT@toc@low@font}
\renewcommand{\cfttabpagefont}{\DUT@toc@page@font}
\renewenvironment{thebibliography}[1]
     {\bib@heading%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand{\bib@heading}{%
  \listed@schapter{\bibname}%
}
\renewenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
  \listed@schapter{\indexname}
  \global\columnwidth\textwidth
  \global\advance\columnwidth-\columnsep
  \global\divide\columnwidth\tw@
  \global\hsize\columnwidth
  \global\linewidth\columnwidth
  \global\@twocolumntrue
  \global\@firstcolumntrue
  \col@number \tw@
                \parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\@DUT@clearpage\fi}
\newcommand\dedicationsname{Dedications}
\let\DUTdedicationsname\dedicationsname
\newcommand\acknowledgmentsname{Acknowledgments}
\let\DUTacknowledgmentsname\acknowledgmentsname
\renewcommand\contentsname{Table of Contents}
\let\DUTcontentsname\contentsname
\renewcommand\listtablename{List of Tables}
\let\DUTlisttablename\listtablename
\renewcommand\listfigurename{List of Figures}
\let\DUTlistfigurename\listfigurename
\newcommand\abstractname{Abstract}
\let\DUTabstractname\abstractname
\renewcommand\bibname{Bibliography}
\let\DUTbibname\bibname
\renewcommand\appendixname{Appendix}
\let\DUTappendixname\appendixname
\newcommand\vitaname{Vita}
\let\DUTvitaname\vitaname
\newcommand{\DUTnames}{%
  \gdef\dedicationsname{\DUTdedicationsname}%
  \gdef\contentsname{\DUTcontentsname}%
  \gdef\listtablename{\DUTlisttablename}%
  \gdef\listfigurename{\DUTlistfigurename}%
  \gdef\bibname{\DUTbibname}%
  \gdef\appendixname{\DUTappendixname}%
  \gdef\vitaname{\DUTvitaname}%
}
\AtEndDocument{\@DUT@blankpage}
\endinput
%%
%% End of file `drexel-thesis.cls'.
