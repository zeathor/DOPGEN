function [fitness] = twoDSineWave(pos)
        fitness = sum(cos(5*pi*pos),2);
end