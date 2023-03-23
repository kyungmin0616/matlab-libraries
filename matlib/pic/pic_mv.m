

num = [70 72 76 77 79 80 82 84 85 86];
num = [87 88 91 94 95 101 104 106 113 116 118 119 120 122 124 127 129 132 134 137 140 141 144 146];
num=[ 147 148 152 156];
num=[ 161 163 164 166 167 169 170 173 176 178 185];
num=[ 187 190 191 192 195 196 198 199 203 204 207 208 209];
num=[ 210 211 215 216 ];
% shift to 2nd folder
num=[ 2 ];
num=[ 3 5 6 7 10 12 16 17 19 20 22 27 30 33 34 36 37:41 42 47 52 53 55 57 62 65 67 73 75 78 79 81 82 84 85 86 ];
% shift to 3nd folder
num=[2:4 6 8:11];



dest='Rotorua';
dest='Napier'
dest='Wellington';
dest='AbelTasman';
dest='Punakaiki';
dest='Haast';
dest='LakeHawea';
dest='Queenstown';
% shift to 2nd folder
dest='Queenstown';
dest='Milford';
% shift to 3nd folder
dest='Auckland';


str=['mkdir ../',dest]
unix(str);

for i=1:length(num)
    %str=['mv NZ1-',num2str(num(i)),'.jpg  ../',dest]
    %str=['mv NZ2-',num2str(num(i)),'.jpg  ../',dest]
    str=['mv NZ3-',num2str(num(i)),'.jpg  ../',dest]
    unix(str);
end
